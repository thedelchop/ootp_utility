defmodule OOTPUtility.Imports.Games.Score do
  alias OOTPUtility.{Games, Imports}

  use OOTPUtility.Imports,
    from: "games_score.csv",
    schema: Games.Score

  def update_changeset(changeset),
    do: Games.Score.put_composite_key(changeset)

  def validate_changeset(%Ecto.Changeset{changes: %{game_id: game_id}} = _) do
    Imports.Agent.in_cache?(:games, game_id)
  end
end
