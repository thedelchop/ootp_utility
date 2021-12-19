defmodule OOTPUtility.Repo.Migrations.CreateTeamRosterMemberships do
  use Ecto.Migration

  def change do
    create table(:team_rosters_membership) do
      add :type, :string
      add :team_id, references(:teams, on_delete: :delete_all)
      add :player_id, references(:players, on_delete: :delete_all)
    end

    create index(:team_rosters_membership, [:team_id, :type])
  end
end
