defmodule OOTPUtility.Repo.Migrations.RenameGameEventsToGameLogLines do
  use Ecto.Migration

  def change do
    rename table(:game_events), to: table(:game_log_lines)
  end
end
