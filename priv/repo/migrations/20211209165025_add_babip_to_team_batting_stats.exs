defmodule OOTPUtility.Repo.Migrations.AddBabipToTeamBattingStats do
  use Ecto.Migration

  def change do
    alter table(:team_batting_stats), do: add(:batting_average_on_balls_in_play, :float)
  end
end
