defmodule OOTPUtilityWeb.Components.Player.Attributes do
  use Surface.LiveComponent

  alias OOTPUtilityWeb.Components.Shared.{Section, Table}
  alias OOTPUtilityWeb.Components.Shared.Table.Column

  @default_column_classes [
    "p-1",
    "md:p-2",
    "whitespace-nowrap",
    "text-center"
  ]

  @default_header_classes [
    "p-1",
    "md:p-2",
    "uppercase",
    "font-medium",
    "text-left"
  ]

  prop attributes, :keyword, required: true

  def render(assigns) do
    ~F"""
      <Section event_target={@myself}>
        <Table id={"player-attributes"} data={{name, ratings} <- @attributes} header_class={&header_class/2} column_class={&column_class/2}>
          <Column label={""}>
            {attribute_name(name)}
          </Column>

          <Column label="Ability">
            {as_graph(Keyword.get(ratings, :ability))}
          </Column>

          <Column label="Vs Left">
            {as_graph(Keyword.get(ratings, :ability_vs_left))}
          </Column>

          <Column label="Vs Right">
            {as_graph(Keyword.get(ratings, :ability_vs_right))}
          </Column>

          <Column label="Talent">
            {as_graph(Keyword.get(ratings, :talent))}
          </Column>
        </Table>
      </Section>
    """
  end

  def handle_event("viewport_resize", _viewport, socket) do
    {:noreply, socket}
  end

  def attribute_name(attribute) do
    Map.get(%{
      gap_power: "Gap",
      home_run_power: "Power",
      avoid_strikeouts: "Avoid Ks",
      },
      attribute,
      attribute |> Phoenix.Naming.humanize() |> OOTPUtilityWeb.Helpers.capitalize_all()
    )
  end

  def as_graph(rating) do
    assigns = %{rating: rating}

    ~F"""
      <div class={"bg-rating-#{@rating * 2}", "w-#{@rating*2}/20", "pl-2", "text-large", "text-gray-700", "text-left"}>{@rating}</div>
    """
  end

  def as_number(rating) do
    assigns = %{rating: rating}

    ~F"""
      <span class={"text-rating-#{@rating * 2}"}>{@rating}</span>
    """
  end

  def header_class(_standing, 0) do
    do_header_class(["text-right"])
  end

  def header_class(_standing, index) when index in [3,4] do
    do_header_class(["hidden", "md:table-cell"])
  end

  def header_class(_col, _index),
    do: do_header_class([])

  def do_header_class(extra_classes \\ []) do
    extra_classes ++ @default_header_classes
  end

  def column_class(_standing, 0) do
    do_column_class(["text-right"])
  end

  def column_class(_standing, index) when index in [3,4] do
    do_column_class(["hidden", "md:table-cell"])
  end

  def column_class(_standing, _index) do
    do_column_class([])
  end

  defp do_column_class(extra_classes) do
    Enum.join(extra_classes ++ @default_column_classes, " ")
  end
end
