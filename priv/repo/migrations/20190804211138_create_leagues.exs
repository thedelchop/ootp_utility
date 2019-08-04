defmodule OOTPUtility.Repo.Migrations.CreateLeagues do
  use Ecto.Migration

  def change do
    create table(:leagues, primary_key: false) do
      add :league_id, :integer, primary_key: true
      add :name, :string
      add :abbr, :string
      add :logo_filename, :string
      add :start_date, :date
      add :league_state, :string
      add :season_year, :integer
      add :historical_year, :integer
      add :league_level, :string
      add :current_date, :date
    end
  end
end
