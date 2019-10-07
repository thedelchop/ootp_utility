defmodule OOTPUtility.Repo.Migrations.CreateCities do
  use Ecto.Migration

  def change do
    create table(:cities) do
      add :name, :string
      add :abbreviation, :string
    end
  end
end
