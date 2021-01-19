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
end
