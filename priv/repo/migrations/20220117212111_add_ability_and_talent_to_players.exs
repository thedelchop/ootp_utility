defmodule OOTPUtility.Repo.Migrations.AddAbilityAndTalentToPlayers do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :ability, :integer
      add :talent, :integer
    end

    create index(:players, [:team_id, :ability])
    create index(:players, [:team_id, :talent])
  end
end
