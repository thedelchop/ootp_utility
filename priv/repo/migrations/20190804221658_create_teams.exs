defmodule OOTPUtility.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams, primary_key: false) do
      add :team_id, :integer, primary_key: true
      add :abbr, :string
      add :name, :string
      add :logo_filename, :string
      add :level, :string

      add :city_id, references(:cities, column: :city_id, on_delete: :nothing)
      add :league_id, references(:leagues, column: :league_id, on_delete: :nothing)
      add :conference_id, references(:conferences, column: :conference_id, on_delete: :nothing)
      add :division_id, references(:divisions, column: :division_id, on_delete: :nothing)
    end

    create index(:teams, [:city_id])
    create index(:teams, [:league_id])
    create index(:teams, [:conference_id])
    create index(:teams, [:division_id])
  end
end
