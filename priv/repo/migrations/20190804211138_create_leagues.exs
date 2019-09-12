defmodule OOTPUtility.Repo.Migrations.CreateLeagues do
  use Ecto.Migration

  def change do
    create table(:leagues) do
      add :name, :string
      add :abbr, :string
      add :logo_filename, :string
      add :start_date, :date
      add :league_state, :string
      add :season_year, :integer
      add :historical_year, :integer
      add :league_level, :string
      add :current_date, :date

      add :parent_league_id, references(:leagues, on_delete: :nothing)
    end

    create index(:leagues, [:parent_league_id])
  end
end
