defmodule OOTPUtility.Repo.Migrations.CreatePlayersMorale do
  use Ecto.Migration

  def change do
    create table(:players_morale, primary_key: false) do
      add :personal_performance, :integer
      add :role_on_team, :integer
      add :team_performance, :integer
      add :team_transactions, :integer
      add :expectation, :integer

      add :player_id, references(:players, on_delete: :delete_all)
    end

    create index(:players_morale, [:player_id])
  end
end
