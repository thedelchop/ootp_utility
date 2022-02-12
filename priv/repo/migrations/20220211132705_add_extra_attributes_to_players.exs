defmodule OOTPUtility.Repo.Migrations.AddExtraAttributesToPlayers do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :groundball_flyball_ratio, :integer
      add :velocity, :integer
      add :arm_slot, :integer

      add :stamina, :integer
      add :hold_runners, :integer

      add :groundball_hitter_type, :integer
      add :flyball_hitter_type, :integer
    end
  end
end
