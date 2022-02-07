defmodule OOTPUtility.Repo.Migrations.CreatePlayerPitchRatings do
  use Ecto.Migration

  def change do
    create table(:players_pitch_ratings) do
      add :type, :integer

      add :fastballl, :integer
      add :slider, :integer
      add :curveball, :integer
      add :screwball, :integer
      add :forkball, :integer
      add :changeup, :integer
      add :sinker, :integer
      add :splitter, :integer
      add :knuckleball, :integer
      add :cutter, :integer
      add :circle_change, :integer
      add :knuckle_curve, :integer

      add :player_id, references(:players, on_delete: :delete_all)
    end

    create index(:players_pitch_ratings, [:player_id])
    create index(:players_pitch_ratings, [:type, :player_id])
  end
end
