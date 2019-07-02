defmodule OOTPUtility.Game.Log.Line do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [where: 3, select: 3]

  schema "game_log_lines" do
    field :formatted_text, :string
    field :game_id, :integer
    field :line, :integer
    field :raw_text, :string
    field :type, :integer
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:game_id, :type, :line, :raw_text, :formatted_text])
    |> validate_required([:game_id, :type, :line, :raw_text])
  end

  @doc """
  Return all of the lines that need to be formatted

  ## Examples

      iex> OOTPUtility.Game.Log.Line.unformatted
  """
  @spec unformatted(Ecto.Query.t() | Line.t()) :: Ecto.Query.t()
  def unformatted(query \\ OOTPUtility.Game.Log.Line) do
    query
    |> Ecto.Queryable.to_query()
    |> where([l], is_nil(l.formatted_text))
  end

  @doc """
  Return all of the Log.Lines that are descriptions of a pitch/outcome

  ## Examples

      iex> OOTPUtility.Game.Log.Line.pitch_descriptors
  """

  @spec pitch_descriptions(Ecto.Query.t() | Line.t()) :: Ecto.Query.t()
  def pitch_descriptions(query \\ OOTPUtility.Game.Log.Line) do
    query
    |> Ecto.Queryable.to_query()
    |> where([l], l.type == 3)
  end

  @doc """
  Return all 'raw_text' fields for the Line

  ## Examples
    iex> OOTPUtility.Game.Log.Line.raw_text()
  """
  @spec raw_text(Ecto.Query.t() | Line.t()) :: Ecto.Query.t()
  def raw_text(query \\ OOTPUtility.Game.Log.Line) do
    query
      |> Ecto.Queryable.to_query()
      |> select([l], l.raw_text)
  end

  @doc """
  Take the Line's raw text, run it through the list of transformations
  and set the result as the Line's formatted text
  """
  @spec format_raw_text(Line.t()) :: String.t()
  def format_raw_text(line) do
    {formatters, _} = Code.eval_file("priv/formatters.ex")

    case Enum.any?(formatters, fn {regex, _} -> Regex.match?(regex, line.raw_text) end) do
      true ->
        Enum.reduce(formatters, line.raw_text, fn 
          formatter, formatted_text ->
            {regex, format_fn} = formatter

            Regex.replace(regex, formatted_text, format_fn)
        end)
      false -> nil
    end
  end
end
