defmodule OOTPUtility.Game.Log.Line do
  use OOTPUtility.Schema, composite_key: [:game_id, :line]
  use OOTPUtility.Imports, attributes: [:id, :game_id, :line, :text, :type, :formatted_text], from: "game_logs.csv"

  import Ecto.Query, only: [where: 3, select: 3, order_by: 3]

  schema "game_log_lines" do
    field :game_id, :integer
    field :line, :integer
    field :text, :string
    field :type, :integer
    field :formatted_text, :string
  end

  @doc """
  Generate the composite id and format the raw text for later processing
  """
  @impl OOTPUtility.Imports
  def sanitize_attributes(attrs) do
    attrs
    |> Map.put(:id, generate_composite_key(attrs))
    |> Map.put(:formatted_text, format_raw_text(attrs))
  end

  @doc """
  If the CSV data contains commas in the "text" that are not correctly escaped, then the CSV
  row can appear to have more columns than expected.  So, for each row that has more columns
  than "game_id", "type", "line" and "text", concat all of the extra columns with a comma to 
  the "text" column.

  When the CSV data has the expected number of columns, just return the row, unchanged.
  """
  @impl OOTPUtility.Imports
  def sanitize_csv_data([game_id, type, line, text | []]), do: [game_id, type, line, text]

  @impl OOTPUtility.Imports
  def sanitize_csv_data([game_id, type, line, text | rest_of_text]) do
    sanitize_csv_data([game_id, type, line, Enum.join([text | rest_of_text], ",")])
  end

  @doc """
  Return all of the lines that need to be formatted

  ## Examples

      iex> OOTPUtility.Game.Log.Line.unformatted
  """
  @spec unformatted(Ecto.Query.t() | Line.t()) :: Ecto.Query.t()
  def unformatted(query \\ __MODULE__) do
    query
    |> Ecto.Queryable.to_query()
    |> where([l], is_nil(l.formatted_text))
  end

  @doc """
  Return all of the lines that have been formatted

  ## Examples

      iex> OOTPUtility.Game.Log.Line.formatted
  """
  @spec formatted(Ecto.Query.t() | Line.t()) :: Ecto.Query.t()
  def formatted(query \\ __MODULE__) do
    query
    |> Ecto.Queryable.to_query()
    |> where([l], not is_nil(l.formatted_text))
  end

  @doc """
  Return all of the Log.Lines that are descriptions of a pitch/outcome

  ## Examples

      iex> OOTPUtility.Game.Log.Line.pitch_descriptors
  """

  @spec pitch_descriptions(Ecto.Query.t() | Line.t()) :: Ecto.Query.t()
  def pitch_descriptions(query \\ __MODULE__) do
    query
    |> Ecto.Queryable.to_query()
    |> where([l], l.type == 3)
  end

  @doc """
  Return all 'text' fields for the Line

  ## Examples
    iex> OOTPUtility.Game.Log.Line.raw_text()
  """
  @spec raw_text(Ecto.Query.t() | Line.t()) :: Ecto.Query.t()
  def raw_text(query \\ __MODULE__) do
    query
    |> Ecto.Queryable.to_query()
    |> select([l], l.text)
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
  Return the 
    
  """
  @spec ordered_by_game(Ecto.Query.t() | Line.t()) :: Ecto.Query.t()
  def ordered_by_game(query \\ __MODULE__) do
    query
    |> Ecto.Queryable.to_query()
    |> order_by([l], [l.game_id, l.line])
  end
end
