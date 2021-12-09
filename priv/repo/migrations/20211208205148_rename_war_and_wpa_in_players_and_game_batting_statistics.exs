defmodule OOTPUtility.Repo.Migrations.RenameWarAndWpaInPlayersAndGameBattingStatistics do
  use Ecto.Migration

  def change do
    alter table(:players_game_pitching_stats), do: remove(:wins_above_replacement, :float)
    alter table(:players_game_batting_stats), do: remove(:war, :float)
    rename(table(:players_game_batting_stats), :wpa, to: :win_probability_added)

    rename(table(:players_career_batting_stats), :war, to: :wins_above_replacement)
    rename(table(:players_career_batting_stats), :wpa, to: :win_probability_added)
  end
end
