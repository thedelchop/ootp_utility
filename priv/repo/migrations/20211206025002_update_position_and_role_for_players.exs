defmodule OOTPUtility.Repo.Migrations.UpdatePositionAndRoleForPlayers do
  use Ecto.Migration

  def change do
    alter table(:players) do
      modify(:position, :string)
      remove(:role)
    end

    create index(:players, [:team_id, :position])
  end
end
