defmodule OOTPUtility.Repo.Migrations.AddParentLeagueToLeagues do
  use Ecto.Migration

  def change do
    alter table(:leagues) do
      add :parent_league_id, references(:leagues, column: :league_id, on_delete: :nothing)
    end

    create index(:leagues, [:parent_league_id])
  end
end
