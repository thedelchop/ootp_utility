defmodule OOTPUtility.Game.Log.Line do
  use OOTPUtility.Schema, composite_key: [:game_id, :line]

  use OOTPUtility.Imports,
    attributes: [:id, :game_id, :line, :text, :type, :formatted_text],
    from: "game_logs.csv"

  import Ecto.Query, only: [order_by: 3, where: 3]
  import Ecto.Queryable, only: [to_query: 1]

  alias __MODULE__
  @type t() :: %__MODULE__{}

  schema "game_log_lines" do
    field :game_id, :integer
    field :line, :integer
    field :text, :string
    field :type, :integer
    field :formatted_text, :string
  end

  @doc """
  Append the composite id and format the raw text for later processing
  """
  def update_import_changeset(changeset) do
    changeset
    |> put_composite_key()
    |> put_formatted_text()
  end

  @doc """
  If the CSV data contains commas in the "text" that are not correctly escaped, then the CSV
  row can appear to have more columns than expected.  So, for each row that has more columns
  than "game_id", "type", "line" and "text", concat all of the extra columns with a comma to 
  the "text" column.

  When the CSV data has the expected number of columns, just return the row, unchanged.
  """
  def sanitize_csv_data([game_id, type, line, text | []]), do: [game_id, type, line, text]

  def sanitize_csv_data([game_id, type, line, text | rest_of_text]) do
    sanitize_csv_data([game_id, type, line, Enum.join([text | rest_of_text], ",")])
  end

  @doc """
  Take the Line's raw text, run it through the list of transformations
  and set the result as the Line's formatted text
  """
  @spec format_raw_text(Line.t()) :: String.t()
  def format_raw_text(line) do
    {formatters, _} = Code.eval_file("priv/formatters.ex")

    case Enum.any?(formatters, fn {regex, _} -> Regex.match?(regex, line.text) end) do
      true ->
        Enum.reduce(formatters, line.text, fn
          formatter, formatted_text ->
            {regex, format_fn} = formatter

            Regex.replace(regex, formatted_text, format_fn)
        end)

      false ->
        nil
    end
  end

  @doc """
  Return a query that scopes the lines to a specified game
  """
  @spec for_game(Ecto.Queryable.t(), number) :: Ecto.Query.t()
  def for_game(query, game_id) do
    query
    |> to_query()
    |> where([l], l.game_id == ^game_id)
  end

  @doc """
  Return the query that includes an ordering of the lines in the query by their game.
  """
  @spec ordered_by_game(Ecto.Query.t() | Line.t()) :: Ecto.Query.t()
  def ordered_by_game(query \\ %Line{}) do
    query
    |> to_query()
    |> order_by([l], [l.game_id, l.line])
  end

  defp put_formatted_text(%Ecto.Changeset{changes: changes} = changeset) do
    change(changeset, %{formatted_text: format_raw_text(changes)})
  end
end
