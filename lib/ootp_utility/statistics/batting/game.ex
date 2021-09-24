defmodule OOTPUtility.Statistics.Batting.Game do
  alias OOTPUtility.Repo
  alias OOTPUtility.Statistics.Batting
  alias OOTPUtility.Games.Game

  import Ecto.Query, only: [from: 2]

  use Batting.PlayerSchema,
    from: "players_game_batting.csv",
    composite_key: [:game_id, :player_id]

  import_player_batting_schema "players_game_batting_stats" do
    belongs_to :game, Game
  end

  def valid_for_import?(%{game_id: game_id}) do
    Repo.exists?(from g in Game, where: g.id == ^game_id)
  end
end
