defmodule OOTPUtility.Repo.Migrations.CreatePlayersPersonalities do
  use Ecto.Migration

  def change do
    create table(:players_personalities) do
      add :greed, :integer
      add :loyalty, :integer
      add :desire_to_win, :integer
      add :work_ethic, :integer
      add :intelligence, :integer
      add :leadership, :integer

      add :player_id, references(:players, on_delete: :delete_all)
    end

    create index(:players_personalities, [:player_id])
  end
end
