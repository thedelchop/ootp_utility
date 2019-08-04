defmodule OOTPUtility.Repo.Migrations.CreateCities do
  use Ecto.Migration

  def change do
    create table(:cities, primary_key: false) do
      add :city_id, :integer, primary_key: true
      add :name, :string
      add :abbreviation, :string
    end
  end
end
