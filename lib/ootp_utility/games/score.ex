defmodule OOTPUtility.Games.Score do
  alias OOTPUtility.{Imports, Repo}
  alias OOTPUtility.Games.Game

  import Ecto.Query, only: [from: 2]

  use Imports.Schema, from: "games_score.csv",
    composite_key: [:game_id, :team, :inning]

  import_schema "games_scores" do
    field :inning, :integer
    field :score, :integer
    field :team, :integer

    belongs_to :game, Game
  end

  def update_import_changeset(changeset) do
    changeset
    |> put_composite_key()
  end

  def valid_for_import?(%{game_id: game_id}) do
    Repo.exists?(from g in Game, where: g.id == ^game_id)
  end
end
