defmodule OOTPUtility.Repo.Migrations.CreateTeamStartingPitchingStats do
  use Ecto.Migration

  def change do
    create table(:team_starting_pitching_stats) do
      add :year, :integer
      add :level_id, :integer
      add :at_bats, :integer
      add :outs_pitched, :integer
      add :batters_faced, :integer
      add :total_bases, :integer
      add :hits_allowed, :integer
      add :strikeouts, :integer
      add :run_support, :integer
      add :walks, :integer
      add :runs_allowed, :integer
      add :earned_runs, :integer
      add :ground_balls, :integer
      add :fly_balls, :integer
      add :pitches_thrown, :integer
      add :games, :integer
      add :wins, :integer
      add :losses, :integer
      add :saves, :integer
      add :singles, :integer
      add :doubles, :integer
      add :triples, :integer
      add :home_runs_allowed, :integer
      add :sacrifices, :integer
      add :sacrifice_flys, :integer
      add :balks, :integer
      add :catchers_interference, :integer
      add :intentional_walks, :integer
      add :wild_pitches, :integer
      add :hit_batsmen, :integer
      add :games_finished, :integer
      add :double_plays, :integer
      add :quality_starts, :integer
      add :save_opportunities, :integer
      add :blown_saves, :integer
      add :relief_appearances, :integer
      add :complete_games, :integer
      add :shutouts, :integer
      add :stolen_bases, :integer
      add :caught_stealing, :integer
      add :holds, :integer
      add :runners_allowed_per_9, :float
      add :batting_average, :float
      add :on_base_percentage, :float
      add :slugging, :float
      add :on_base_plus_slugging, :float
      add :hits_allowed_per_9, :float
      add :strikeouts_per_9, :float
      add :home_runs_allowed_per_9, :float
      add :walks_allowed_per_9, :float
      add :complete_game_percentage, :float
      add :fielding_independent_pitching, :float
      add :quality_start_percentage, :float
      add :winning_percentage, :float
      add :run_support_per_start, :float
      add :save_percentage, :float
      add :blown_save_percentage, :float
      add :games_finished_percentage, :float
      add :earned_run_average, :float
      add :pitches_per_game, :float
      add :walks_hits_per_inning_pitched, :float
      add :ground_ball_percentage, :float
      add :strikeouts_to_walks_ratio, :float
      add :batting_average_on_balls_in_play, :float

      add :team_id, references(:teams, on_delete: :delete_all)
      add :league_id, references(:leagues, on_delete: :delete_all)
    end

    create index(:team_starting_pitching_stats, [:team_id])
    create index(:team_starting_pitching_stats, [:league_id])
  end
end
