defmodule OOTPUtility.Repo.Migrations.CreateDivisions do
  use Ecto.Migration

  def change do
    create table(:divisions) do
      add :name, :string

      add :league_id, :string
      add :conference_id, :string
    end

    create index(:divisions, [:league_id])
    create index(:divisions, [:conference_id])
  end
end
