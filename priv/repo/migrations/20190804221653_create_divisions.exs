defmodule OOTPUtility.Repo.Migrations.CreateDivisions do
  use Ecto.Migration

  def change do
    create table(:divisions, primary_key: false) do
      add :division_id, :integer, primary_key: true
      add :name, :string

      add :league_id, references(:leagues, column: :league_id, on_delete: :nothing)
      add :conference_id, references(:conferences, column: :conference_id, on_delete: :nothing)
    end

    create index(:divisions, [:league_id])
    create index(:divisions, [:conference_id])
  end
end
