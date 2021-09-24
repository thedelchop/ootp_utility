defmodule OOTPUtility.Repo.Migrations.CreatePlayerGameBattingStats do
 use Ecto.Migration

  def change do
    create table(:players_game_batting_stats) do
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
      add :triples, :integer
      add :ubr, :float
      add :war, :float
      add :wpa, :float
      add :pitches_seen, :integer

      add :player_id, references(:players, on_delete: :delete_all)
      add :team_id, references(:teams, on_delete: :nothing)
      add :league_id, references(:leagues, on_delete: :delete_all)
      add :game_id, references(:games, on_delete: :delete_all)
    end

    create index(:players_game_batting_stats, [:player_id])
    create index(:players_game_batting_stats, [:team_id])
    create index(:players_game_batting_stats, [:league_id])
    create index(:players_game_batting_stats, [:game_id])
  end
end
