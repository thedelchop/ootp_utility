defmodule OOTPUtility.Statistics.Pitching.Player do
  alias OOTPUtility.Statistics.Pitching.Player

  use Player.Schema,
    from: "players_career_pitching_stats.csv",
    composite_key: [:year, :team_id, :player_id, :split_id]

  player_pitching_schema "players_career_pitching_stats" do
    field :split_id, :integer
  end
end
