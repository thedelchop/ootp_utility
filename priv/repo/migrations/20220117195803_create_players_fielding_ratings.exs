defmodule OOTPUtility.Repo.Migrations.CreatePlayersFieldingRatings do
  use Ecto.Migration

  def change do
    create table(:players_fielding_ratings, primary_key: false) do
      add :infield_range, :integer
      add :infield_error, :integer
      add :infield_arm, :integer
      add :turn_double_play, :integer

      add :outfield_range, :integer
      add :outfield_error, :integer
      add :outfield_arm, :integer

      add :catcher_ability, :integer
      add :catcher_arm, :integer

      add :player_id, references(:players, on_delete: :delete_all)
    end

    create index(:players_fielding_ratings, [:player_id])
  end
end
