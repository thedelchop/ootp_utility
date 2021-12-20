defmodule OOTPUtility.Repo.Migrations.RemoveLeagueIdFromPlayers do
  use Ecto.Migration

  def change do
    alter table(:players) do
      remove(:league_id, references(:league, on_delete: :delete_all), null: true)
    end
  end
end
