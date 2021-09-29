defmodule OOTPUtility.Repo.Migrations.CreatePlayersCareerPitchingStats do
  use Ecto.Migration

  def change do
    create table(:players_career_pitching_stats) do
      add :at_bats, :integer
      add :balks, :integer
      add :batting_average, :float
      add :batting_average_on_balls_in_play, :float
      add :blown_save_percentage, :float
      add :blown_saves, :integer
      add :catchers_interference, :integer
      add :caught_stealing, :integer
      add :complete_game_percentage, :float
      add :complete_games, :integer
      add :double_plays, :integer
      add :doubles, :integer
      add :earned_run_average, :float
      add :earned_runs, :integer
      add :fly_balls, :integer
      add :games, :integer
      add :games_started, :integer
      add :games_finished, :integer
      add :games_finished_percentage, :float
      add :ground_ball_percentage, :float
      add :ground_balls, :integer
      add :hit_by_pitch, :integer
      add :hits, :integer
      add :hits_per_9, :float
      add :holds, :integer
      add :home_runs, :integer
      add :home_runs_per_9, :float
      add :inherited_runners, :integer
      add :inherited_runners_scored, :integer
      add :inherited_runners_scored_percentage, :float
      add :intentional_walks, :integer
      add :level_id, :string
      add :leverage_index, :float
      add :losses, :integer
      add :on_base_percentage, :float
      add :on_base_plus_slugging, :float
      add :outs_pitched, :integer
      add :pitches_per_game, :float
      add :pitches_thrown, :integer
      add :plate_appearances, :integer
      add :quality_start_percentage, :float
      add :quality_starts, :integer
      add :relief_appearances, :integer
      add :run_support, :integer
      add :run_support_per_start, :float
      add :runs, :integer
      add :runs_per_9, :float
      add :sacrifice_flys, :integer
      add :sacrifices, :integer
      add :save_opportunities, :integer
      add :save_percentage, :float
      add :saves, :integer
      add :shutouts, :integer
      add :singles, :integer
      add :slugging, :float
      add :split_id, :integer
      add :stolen_bases, :integer
      add :strikeouts, :integer
      add :strikeouts_per_9, :float
      add :strikeouts_to_walks_ratio, :float
      add :total_bases, :integer
      add :triples, :integer
      add :walks, :integer
      add :walks_hits_per_inning_pitched, :float
      add :walks_per_9, :float
      add :wild_pitches, :integer
      add :win_probabilty_added, :float
      add :winning_percentage, :float
      add :wins, :integer
      add :wins_above_replacement, :float
      add :year, :integer

      add :team_id, references(:teams, on_delete: :nothing)
      add :league_id, references(:leagues, on_delete: :nothing)
      add :player_id, references(:players, on_delete: :delete_all)
    end

    create index(:players_career_pitching_stats, [:team_id])
    create index(:players_career_pitching_stats, [:league_id])
    create index(:players_career_pitching_stats, [:player_id])
  end
end
