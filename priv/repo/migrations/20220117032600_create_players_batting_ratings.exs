defmodule OOTPUtility.Repo.Migrations.CreatePlayersBattingRatings do
  use Ecto.Migration

  def change do
    create table(:players_batting_ratings, primary_key: false) do
      add :type, :integer

      add :contact, :integer
      add :gap_power, :integer
      add :home_run_power, :integer
      add :eye, :integer
      add :avoid_strikeouts, :integer

      add :bunt, :integer
      add :bunt_for_hit, :integer
      add :groundball_hitter_type, :integer
      add :flyball_hitter_type, :integer

      add :player_id, references(:players, on_delete: :delete_all)
    end

    create index(:players_batting_ratings, [:player_id])
    create index(:players_batting_ratings, [:type, :player_id])
  end
end
