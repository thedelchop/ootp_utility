defmodule OOTPUtility.Repo.Migrations.RemoveFormattedTextFromGameLogLine do
  use Ecto.Migration

  def change do
    drop index(:game_log_lines, [:type, :formatted_text],
             where: "formatted_text IS NULL AND type = 3",
             name: :raw_game_log_lines_of_pitches
           )

    alter table(:game_log_lines) do
      remove :formatted_text, :string, default: ""
    end
  end
end
