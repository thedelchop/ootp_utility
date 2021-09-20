defmodule OOTPUtility.Repo.Migrations.CreateTeamFieldingStats do
  use Ecto.Migration

  def change do
    create table(:team_fielding_stats) do
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
      add :catcher_earned_run_average, :float

      add :team_id, references(:teams, on_delete: :delete_all)
      add :league_id, references(:leagues, on_delete: :delete_all)
    end

    create index(:team_fielding_stats, [:team_id])
    create index(:team_fielding_stats, [:league_id])
  end
end
