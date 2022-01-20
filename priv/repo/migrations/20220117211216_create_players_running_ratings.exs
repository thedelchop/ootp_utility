defmodule OOTPUtility.Repo.Migrations.CreatePlayersRunningRatings do
  use Ecto.Migration

  def change do
    create table(:players_running_ratings, primary_key: false) do
      add :speed, :integer
      add :stealing_ability, :integer
      add :baserunning_ability, :integer

      add :player_id, references(:players, on_delete: :delete_all)
    end

    create index(:players_running_ratings, [:player_id])
  end
end
