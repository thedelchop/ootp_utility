defmodule OOTPUtility.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :abbr, :string
      add :name, :string
      add :logo_filename, :string
      add :level, :string

      add :city_id, references(:cities, on_delete: :nothing)
      add :league_id, references(:leagues, on_delete: :nothing)
      add :conference_id, references(:conferences, on_delete: :nothing)
      add :division_id, references(:divisions, on_delete: :nothing)
    end

    create index(:teams, [:city_id])
    create index(:teams, [:league_id])
    create index(:teams, [:conference_id])
    create index(:teams, [:division_id])
  end
end
