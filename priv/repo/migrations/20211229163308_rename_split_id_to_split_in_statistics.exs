defmodule OOTPUtility.Repo.Migrations.RenameSplitIdToSplitInStatistics do
  use Ecto.Migration

  def change do
    [
      "players_career_pitching_stats",
      "players_career_batting_stats",
      "players_game_pitching_stats"
    ]
    |> Enum.each(&rename(table(&1), :split_id, to: :split))
  end
end
