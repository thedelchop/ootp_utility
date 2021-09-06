defmodule OOTPUtility.Repo.Migrations.CreateLeagues do
  use Ecto.Migration

  def change do
    create table(:leagues) do
      add :abbr, :string
      add :current_date, :date
      add :league_level, :string
      add :logo_filename, :string
      add :name, :string
      add :season_year, :integer
      add :start_date, :date

      add :parent_league_id, :string
    end
  end
end
