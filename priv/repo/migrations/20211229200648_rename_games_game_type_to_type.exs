defmodule OOTPUtility.Repo.Migrations.RenameGamesGameTypeToType do
  use Ecto.Migration

  def change, do: rename(table(:games), :game_type, to: :type)
end
