defmodule OOTPUtility.Repo.Migrations.UpdatePlayersBatsAndThrowsToStrings do
  use Ecto.Migration

  def change do
    alter table(:players) do
      modify(:throws, :string)
      modify(:bats, :string)
    end

    create index(:players, [:throws])
    create index(:players, [:bats])
  end
end
