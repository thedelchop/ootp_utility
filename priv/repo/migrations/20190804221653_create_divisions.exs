defmodule OOTPUtility.Repo.Migrations.CreateDivisions do
  use Ecto.Migration

  def change do
    create table(:divisions) do
      add :name, :string

      add :league_id, references(:leagues, on_delete: :nothing)
      add :conference_id, references(:conferences, on_delete: :nothing)
    end

    create index(:divisions, [:league_id])
  end
end
