defmodule OOTPUtility.Repo.Migrations.RenameStatisticsLevelIdAndLeaguesLeagueLevelToLevel do
  use Ecto.Migration

  def change do
    [
      "team_batting_stats",
      "team_fielding_stats",
      "team_pitching_stats",
      "team_bullpen_pitching_stats",
      "team_starting_pitching_stats",
      "players_career_batting_stats",
      "players_career_fielding_stats",
      "players_career_pitching_stats",
      "players_game_batting_stats",
      "players_game_pitching_stats"
    ]
    |> Enum.each(&rename(table(&1), :level_id, to: :level))

    rename table("leagues"), :league_level, to: :level
  end
end
