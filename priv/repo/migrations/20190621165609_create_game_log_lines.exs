defmodule OOTPUtility.Repo.Migrations.CreateGameLogLines do
  use Ecto.Migration

  def change do
    create table(:game_log_lines) do
      add :game_id, :integer
      add :type, :integer
      add :line, :integer
      add :text, :text
      add :formatted_text, :text
    end

    create index(:game_log_lines, [:game_id])
    create index(:game_log_lines, [:game_id, :line])
  end
end
