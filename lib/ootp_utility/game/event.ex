defmodule OOTPUtility.Game.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "game_events" do
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
end
