defmodule OOTPUtility.Game.Log.Line do
  use OOTPUtility.Schema
  import Ecto.Query, only: [where: 3, select: 3]
  import OOTPUtility.Imports, only: [import_from_path: 4]

  schema "game_log_lines" do
    field :game_id, :integer
    field :line, :integer
    field :text, :string
    field :type, :integer
    field :formatted_text, :string
  end

  def import_from_path(path) do
    import_from_path(path, __MODULE__, &sanitize_import_attributes/1, &import_changeset/1)
  end

  def import_changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> apply_changes()
  end

  @doc false
  def changeset(line, attrs) do
    line
    |> cast(attrs, [:game_id, :type, :line, :text, :formatted_text])
    |> validate_required([:game_id, :type, :line, :text])
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

  defp sanitize_import_attributes([game_id, type, line, text]) do
    [
      game_id,
      type,
      line,
      text
    ]
  end

  defp sanitize_import_attributes([game_id, type, line, text | rest_of_text]) do
    [
      game_id,
      type,
      line,
      Enum.join([text | rest_of_text], ",")
    ]
  end


end
