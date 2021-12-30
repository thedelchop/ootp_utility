defmodule OOTPUtility.Repo.Migrations.UpdatePositionAndRoleForPlayers do
  use Ecto.Migration

  def change do
    alter table(:players), do: remove(:role)

    create index(:players, [:team_id, :position])
  end
end
