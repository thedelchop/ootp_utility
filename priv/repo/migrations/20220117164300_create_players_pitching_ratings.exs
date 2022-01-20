defmodule OOTPUtility.Repo.Migrations.CreatePlayersPitchingRatings do
  use Ecto.Migration

  def change do
    create table(:players_pitching_ratings, primary_key: false) do
      add :type, :integer

      add :stuff, :integer
      add :movement, :integer
      add :control, :integer

      add :groundball_flyball_ratio, :integer
      add :velocity, :integer
      add :arm_slot, :integer

      add :stamina, :integer
      add :hold_runners, :integer

      add :player_id, references(:players, on_delete: :delete_all)
    end

    create index(:players_pitching_ratings, [:player_id])
    create index(:players_pitching_ratings, [:type, :player_id])
  end
end
