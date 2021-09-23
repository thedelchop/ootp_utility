defmodule OOTPUtility.Repo.Migrations.CreatePlayerCareerBattingStats do
  use Ecto.Migration

  def change do
    create table(:players_career_batting_stats) do
      add :level_id, :integer
      add :year, :integer
      add :games, :integer
      add :games_started, :integer
      add :at_bats, :integer
      add :walks, :integer
      add :catchers_interference, :integer
      add :caught_stealing, :integer
      add :doubles, :integer
      add :grounded_into_double_play, :integer
      add :hits, :integer
      add :hit_by_pitch, :integer
      add :home_runs, :integer
      add :intentional_walks, :integer
      add :strikeouts, :integer
      add :plate_appearances, :integer
      add :position, :integer
      add :runs, :integer
      add :runs_batted_in, :integer
      add :stolen_bases, :integer
      add :sacrifice_flys, :integer
      add :sacrifices, :integer
      add :stint, :integer
      add :triples, :integer
      add :ubr, :float
      add :war, :float
      add :wpa, :float
      add :pitches_seen, :integer
      add :split_id, :integer

      add :player_id, references(:players, on_delete: :delete_all), null: true
      add :team_id, references(:teams, on_delete: :nothing), null: true
      add :league_id, references(:leagues, on_delete: :nothing), null: true
    end

    create index(:players_career_batting_stats, [:player_id])
    create index(:players_career_batting_stats, [:team_id])
    create index(:players_career_batting_stats, [:league_id])
  end
end
