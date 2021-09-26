defmodule OOTPUtility.Statistics.Batting.Player do
  alias OOTPUtility.Statistics.Batting

  use Batting.PlayerSchema,
    from: "players_career_batting_stats.csv",
    composite_key: [:year, :team_id, :player_id, :split_id]

  player_batting_schema "players_career_batting_stats" do
    field :split_id, :integer
    field :pitches_seen, :integer
  end
end
