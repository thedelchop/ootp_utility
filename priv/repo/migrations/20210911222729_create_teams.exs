defmodule OOTPUtility.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :abbr, :string
      add :level, :integer
      add :logo_filename, :string
      add :league_id, references(:leagues, on_delete: :delete_all)
      add :conference_id, references(:conferences, on_delete: :delete_all)
      add :division_id, references(:divisions, on_delete: :delete_all)
    end

    create index(:teams, [:league_id])
    create index(:teams, [:conference_id])
    create index(:teams, [:division_id])
  end
end
