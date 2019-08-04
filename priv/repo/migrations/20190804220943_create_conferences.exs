defmodule OOTPUtility.Repo.Migrations.CreateConferences do
  use Ecto.Migration

  def change do
    create table(:conferences, primary_key: false) do
      add :conference_id, :integer, primary_key: true
      add :name, :string
      add :abbr, :string
      add :designated_hitter, :boolean, default: false, null: false
      add :league_id, references(:leagues, column: :league_id, on_delete: :nothing)
    end

    create index(:conferences, [:league_id])
  end
end
