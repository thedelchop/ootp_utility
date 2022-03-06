defmodule OOTPUtilityWeb.Components.Shared.Table do
  @moduledoc """
  A TailwindUI HTML table.

  You can create a table by passing `data` to it and defining
  columns using the `Table.Column` component.

  Look in the documentation for `Table.Column` for information on how to do sorting.
  """

  use Surface.LiveComponent
  alias OOTPUtilityWeb.Components.Shared.Icons.Chevron

  @doc "The data that populates the table internal"
  prop data, :list, required: true

  @doc "The table is expanded (full-width)"
  prop expanded, :boolean, default: true

  @doc """
  A function that returns a class for the item's underlying `<tr>`
  element. The function receives the item and index related to
  the row.
  """
  prop row_class, :fun
  prop header_class, :fun
  prop column_class, :fun

  @doc "The columns of the table"
  slot cols, args: [item: ^data], required: true

  @doc "Internal holder of sorted data"
  data sorted_data, :list, default: []

  @doc "Holder of what we're sorting by"
  data sorted_by, :any, default: nil

  @doc "Clicking column again should reverse search"
  data sort_reverse, :boolean, default: false

  data updated?, :boolean, default: false

  def update(assigns, socket) do
    assigns = Map.put(assigns, :updated?, assigns[:data] != socket.assigns[:data])

    socket =
      socket
      |> assign(assigns)

    {:ok, assign(socket, :sorted_data, sorted_data(socket.assigns))}
  end

  def render(assigns) do
    ~F"""
      <table class={table_classes(@expanded)}>
        <thead class={"bg-gray-100"}>
          <tr>
            {#for {col, index} <- Enum.with_index(@cols)}
              <th class={header_class_fun(@header_class).(col, index)}>
                {#if !is_nil(col.sort_by) && assigns.sorted_by == col.label}
                <a :on-click="sorted_click" phx-value-value={col.label} href="#">
                  <span>
                  {col.label}
                  <Chevron direction={if assigns.sort_reverse, do: :up, else: :down}/>
                  </span>
                </a>
                {/if}
                {#if !is_nil(col.sort_by) && assigns.sorted_by != col.label}
                  <a :on-click="sorted_click" phx-value-value={col.label} href="#">
                    {col.label}
                  </a>
                {/if}
                {#if is_nil(col.sort_by)}
                  {col.label}
                {/if}
              </th>
            {/for}
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <tr
            :for={{item, index} <- Enum.with_index(@sorted_data)}
            class={row_class_fun(@row_class).(item, index)}>
            <td :for.index={index <- @cols} class={column_class_fun(@column_class).(item, index)}>
              <#slot name="cols" index={index} :args={item: item}/>
            </td>
          </tr>
        </tbody>
      </table>
    """
  end

  def table_classes(expanded) do
    [
      "divide-y",
      "divide-gray-200",
      "table-fixed",
      "min-w-full": expanded
    ]
  end

  def handle_event(
        "sorted_click",
        %{"value" => sort_by_new},
        %{assigns: %{sorted_by: sorted_by, sort_reverse: sort_reverse}} = socket
      ) do
    socket =
      cond do
        sorted_by != sort_by_new ->
          socket
          |> assign(:sorted_by, sort_by_new)
          |> assign(:sort_reverse, false)

        sorted_by == sort_by_new ->
          assign(socket, :sort_reverse, !sort_reverse)
      end

    socket = assign(socket, :sorted_data, sorted_data(socket.assigns))
    {:noreply, socket}
  end

  # credo:disable-for-next-line
  defp sorted_data(%{
         sorted_by: sorted_by,
         data: data,
         cols: cols,
         sorted_data: sorted_data,
         sort_reverse: sort_reverse,
         updated?: updated?
       }) do
    cond do
      !is_nil(sorted_by) ->
        # We find the column that matches the sorted_by assign and extract the sort_by as sorter
        sorter =
          Enum.reduce_while(cols, nil, fn
            %{label: ^sorted_by, sort_by: sorter}, _acc ->
              {:halt, sorter}

            _col, acc ->
              {:cont, acc}
          end)

        sorted_data =
          case sorter do
            sorter when is_binary(sorter) ->
              # We have to try to fetch both by string and atom key as
              # we don't know if the data is using string or atom keys.
              # credo:disable-for-next-line
              Enum.sort_by(data, fn i ->
                Map.get(i, sorter) || Map.get(i, String.to_atom(sorter))
              end)

            sorter when is_function(sorter) ->
              Enum.sort_by(data, sorter)

            sorter when is_list(sorter) ->
              Enum.sort_by(data, &get_nested_data(&1, sorter))

            {sorter, comparer} when is_function(sorter) and is_function(comparer) ->
              Enum.sort_by(data, sorter, comparer)

            {sorter, comparer} when is_list(sorter) and is_function(comparer) ->
              Enum.sort_by(data, &get_nested_data(&1, sorter), comparer)

            nil ->
              data
          end

        sorted_data =
          if sort_reverse == true do
            Enum.reverse(sorted_data)
          else
            sorted_data
          end

        sorted_data

      is_nil(sorted_data) or updated? ->
        data

      true ->
        sorted_data
    end
  end

  defp row_class_fun(nil), do: fn _, _ -> "" end
  defp row_class_fun(row_class), do: row_class

  defp header_class_fun(nil), do: fn _, _ -> "" end
  defp header_class_fun(header_class), do: header_class

  defp column_class_fun(nil), do: fn _, _ -> "" end
  defp column_class_fun(column_class), do: column_class

  defp get_nested_data(row, keys) do
    Enum.reduce_while(keys, row, fn
      key, acc when (is_atom(key) or is_binary(key)) and is_map(acc) ->
        {:cont, Map.get(acc, key)}

      index, acc when is_integer(index) and is_list(acc) ->
        {:cont, Enum.at(acc, index)}

      _key, value ->
        {:halt, value}
    end)
  end
end
