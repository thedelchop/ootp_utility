defmodule OOTPUtility.Repo.Migrations.CreateDivisions do
  use Ecto.Migration

  def change do
    create table(:divisions) do
      add :name, :string
      add :league_id, references(:leagues, on_delete: :delete_all)
      add :conference_id, references(:conferences, on_delete: :delete_all)
    end

    create index(:divisions, [:league_id])
    create index(:divisions, [:conference_id])
  end
end
