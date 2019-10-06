defmodule OOTPUtility.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :abbr, :string
      add :name, :string
      add :logo_filename, :string
      add :level, :string

      add :league_id, :string
      add :conference_id, :string
      add :division_id, :string
    end

    create index(:teams, [:league_id])
    create index(:teams, [:conference_id])
    create index(:teams, [:division_id])
  end
end
