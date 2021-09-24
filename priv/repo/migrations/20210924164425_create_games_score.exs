defmodule OOTPUtility.Repo.Migrations.CreateGamesScore do
  use Ecto.Migration

  def change do
    create table(:games_scores) do
      add :inning, :integer
      add :team, :integer
      add :game_id, references(:games, on_delete: :nothing)
      add :score, :integer
    end

    create index(:games_scores, [:game_id])
  end
end
