defmodule OOTPUtility.Repo.Migrations.CreateConferences do
  use Ecto.Migration

  def change do
    create table(:conferences) do
      add :abbr, :string
      add :name, :string
      add :designated_hitter, :boolean, default: false, null: false
      add :league_id, references(:leagues, on_delete: :delete_all)
    end

    create index(:conferences, [:league_id])
  end
end
