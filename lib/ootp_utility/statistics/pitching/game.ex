defmodule OOTPUtility.Statistics.Pitching.Game do
  alias OOTPUtility.Statistics.Pitching.Player
  alias OOTPUtility.{Games,Repo}
  alias OOTPUtility.Teams.Team

  import Ecto.Query, only: [from: 2]

  use Player.Schema,
    from: "players_game_pitching_stats.csv",
    composite_key: [:game_id, :player_id]

  player_pitching_schema "players_game_pitching_stats" do
    belongs_to :game, Games.Game
  end

  def valid_for_import?(%{team_id: team_id} = _attrs) do
    Repo.exists?(from t in Team, where: t.id == ^team_id)
  end
end
