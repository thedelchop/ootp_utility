defmodule OOTPUtility.Repo.Migrations.CreateConferences do
  use Ecto.Migration

  def change do
    create table(:conferences) do
      add :name, :string
      add :abbr, :string
      add :designated_hitter, :boolean, default: false, null: false
      add :league_id, :string
    end

    create index(:conferences, [:league_id])
  end
end
