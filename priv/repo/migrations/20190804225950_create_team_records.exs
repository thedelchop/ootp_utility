defmodule OOTPUtility.Repo.Migrations.CreateTeamRecords do
  use Ecto.Migration

  def change do
    create table(:team_records) do
      add :games, :integer
      add :wins, :integer
      add :losses, :integer
      add :position, :integer
      add :winning_percentage, :float
      add :games_behind, :float
      add :streak, :integer
      add :magic_number, :integer
      add :game_date, :date

      add :team_id, references(:teams, on_delete: :nothing)
    end

    create index(:team_records, [:team_id])
    create index(:team_records, [:game_date])
  end
end
