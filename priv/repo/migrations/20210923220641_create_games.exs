defmodule OOTPUtility.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :attendance, :integer
      add :date, :date
      add :time, :time
      add :game_type, :integer
      add :played, :boolean, default: false, null: false
      add :dh, :boolean, default: false, null: false
      add :innings, :integer
      add :away_team_runs, :integer
      add :home_team_runs, :integer
      add :away_team_hits, :integer
      add :home_team_hits, :integer
      add :away_team_errors, :integer
      add :home_team_errors, :integer
      add :league_id, references(:leagues, on_delete: :nothing)
      add :home_team_id, references(:teams, on_delete: :nothing)
      add :away_team_id, references(:teams, on_delete: :nothing)
      add :winning_pitcher_id, references(:players, on_delete: :nothing), null: true
      add :losing_pitcher_id, references(:players, on_delete: :nothing), null: true
      add :save_pitcher_id, references(:players, on_delete: :nothing), null: true
      add :away_team_starter_id, references(:players, on_delete: :nothing), null: true
      add :home_team_starter_id, references(:players, on_delete: :nothing), null: true
    end

    create index(:games, [:league_id])
    create index(:games, [:home_team_id])
    create index(:games, [:away_team_id])
    create index(:games, [:winning_pitcher_id])
    create index(:games, [:losing_pitcher_id])
    create index(:games, [:save_pitcher_id])
    create index(:games, [:away_team_starter_id])
    create index(:games, [:home_team_starter_id])
  end
end
