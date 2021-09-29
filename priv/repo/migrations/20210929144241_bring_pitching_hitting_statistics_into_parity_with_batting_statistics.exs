defmodule OOTPUtility.Repo.Migrations.BringPitchingHittingStatisticsIntoParityWithBattingStatistics do
  use Ecto.Migration

  def change do
    pitching_tables = [:team_pitching_stats, :team_starting_pitching_stats, :team_bullpen_pitching_stats]

    for table_name <- pitching_tables do
      table(table_name)
      |> rename(:runs_allowed, to: :runs)
      |> rename(:home_runs_allowed, to: :home_runs)
      |> rename(:batters_faced, to: :plate_appearances)
      |> rename(:hits_allowed, to: :hits)
      |> rename(:hit_batsmen, to: :hit_by_pitch)
      |> rename(:walks_allowed_per_9, to: :walks_per_9)
      |> rename(:hits_allowed_per_9, to: :hits_per_9)
      |> rename(:home_runs_allowed_per_9, to: :home_runs_per_9)
      |> rename(:runners_allowed_per_9, to: :runs_per_9)

      alter table(table_name) do
        add :games_started, :integer
      end
    end
  end
end
