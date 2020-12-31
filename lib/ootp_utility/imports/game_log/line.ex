defmodule OOTPUtility.Imports.GameLog.Line do
  @type t() :: %__MODULE__{}

  use OOTPUtility.Schema, composite_key: [:game_id, :line]

  use OOTPUtility.Imports,
    attributes: [:id, :game_id, :line, :text, :type, :formatted_text],
    from: "game_logs.csv"

  alias __MODULE__

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

  defp put_formatted_text(%Ecto.Changeset{changes: changes} = changeset) do
    change(changeset, %{formatted_text: format_raw_text(changes)})
  end
end
