defmodule OOTPUtility.Statistics.Batting.Player do
  alias OOTPUtility.Statistics.Batting.Player

  use Player.Schema,
    composite_key: [:player_id, :league_id, :team_id, :level_id, :split_id]

  player_batting_schema "players_career_batting_stats" do
    field :split_id, :integer
    field :pitches_seen, :integer
  end
end
