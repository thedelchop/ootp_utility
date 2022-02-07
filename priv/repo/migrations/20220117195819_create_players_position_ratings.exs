defmodule OOTPUtility.Repo.Migrations.CreatePlayersPositionRatings do
  use Ecto.Migration

  def change do
    create table(:players_position_ratings) do
      add :pitcher, :integer
      add :catcher, :integer
      add :first_base, :integer
      add :second_base, :integer
      add :third_base, :integer
      add :shortstop, :integer
      add :left_field, :integer
      add :center_field, :integer
      add :right_field, :integer

      add :player_id, references(:players, on_delete: :delete_all)
    end

    create index(:players_position_ratings, [:player_id])
  end
end
