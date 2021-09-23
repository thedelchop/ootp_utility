defmodule OOTPUtility.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :first_name, :string
      add :last_name, :string
      add :nickname, :string
      add :weight, :integer
      add :height, :integer
      add :age, :integer
      add :date_of_birth, :string
      add :experience, :integer
      add :uniform_number, :integer
      add :bats, :integer
      add :throws, :integer
      add :position, :integer
      add :role, :integer
      add :free_agent, :boolean, default: false, null: false
      add :retired, :boolean, default: false, null: false
      add :local_popularity, :integer
      add :national_popularity, :integer

      add :team_id, references(:teams, on_delete: :delete_all), null: true
      add :league_id, references(:leagues, on_delete: :delete_all), null: true
      add :organization_id, references(:teams, on_delete: :delete_all), null: true
    end

    create index(:players, [:league_id])
    create index(:players, [:organization_id])
    create index(:players, [:team_id])
  end
end
