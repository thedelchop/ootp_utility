defmodule OOTPUtility.Game.Log.Line do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

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
    from l in query, where: is_nil(l.formatted_text)
  end

  @doc """
  Return all of the Log.Lines that are descriptions of a pitch/outcome

  ## Examples

      iex> OOTPUtility.Game.Log.Line.pitch_descriptors
  """

  @spec pitch_descriptions(Ecto.Query.t() | Line.t()) :: Ecto.Query.t()
  def pitch_descriptions(query \\ OOTPUtility.Game.Log.Line) do
    from l in query, where: l.type == 3
  end
end
