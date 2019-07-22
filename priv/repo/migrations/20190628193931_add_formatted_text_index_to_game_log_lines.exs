defmodule OOTPUtility.Repo.Migrations.AddFormattedTextIndexToGameLogLines do
  use Ecto.Migration

  def change do
    create index(:game_log_lines, [:type, :formatted_text],
             where: "formatted_text IS NULL AND type = 3",
             name: :raw_game_log_lines_of_pitches
           )
  end
end
