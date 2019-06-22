defmodule OOTPUtility.Repo.Migrations.CreateGameEvents do
  use Ecto.Migration

  def change do
    create table(:game_events) do
      add :game_id, :integer
      add :type, :integer
      add :line, :integer
      add :raw_text, :text
      add :formatted_text, :text
    end
    
    create index(:game_events, [:game_id])
  end
end
