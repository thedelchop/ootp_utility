defmodule OOTPUtility.Imports.Games.Score do
  alias OOTPUtility.{Games, Repo}

  import Ecto.Query, only: [from: 2]

  use OOTPUtility.Imports,
    from: "games_score.csv",
    schema: Games.Score

  def update_changeset(changeset),
    do: Games.Score.put_composite_key(changeset)

  def validate_changeset(%Ecto.Changeset{changes: %{game_id: game_id}} = _changeset) do
    Repo.exists?(from g in Games.Game, where: g.id == ^game_id)
  end
end
