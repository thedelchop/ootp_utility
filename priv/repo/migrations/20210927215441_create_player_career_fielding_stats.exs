defmodule OOTPUtility.Repo.Migrations.CreatePlayerCareerFieldingStats do
  use Ecto.Migration

  def change do
    create table(:players_career_fielding_stats) do
      add :year, :integer
      add :level_id, :integer
      add :games, :integer
      add :games_started, :integer
      add :total_chances, :integer
      add :assists, :integer
      add :put_outs, :integer
      add :errors, :integer
      add :double_plays, :integer
      add :triple_plays, :integer
      add :past_balls, :integer
      add :stolen_base_attempts, :integer
      add :runners_thrown_out, :integer
      add :outs_played, :integer
      add :fielding_percentage, :float
      add :range_factor, :float
      add :runners_thrown_out_percentage, :float
      add :zone_rating, :float
      add :reached_on_error, :integer
      add :position, :integer

      add :team_id, references(:teams, on_delete: :nothing)
      add :league_id, references(:leagues, on_delete: :nothing)
      add :player_id, references(:players, on_delete: :nothing)
    end

    create index(:players_career_fielding_stats, [:team_id])
    create index(:players_career_fielding_stats, [:league_id])
    create index(:players_career_fielding_stats, [:player_id])
  end
end
