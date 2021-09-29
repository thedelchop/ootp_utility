defmodule OOTPUtility.Statistics.Pitching.Player do
  alias OOTPUtility.Statistics.Pitching.Player
  alias OOTPUtility.Players

  use Player.Schema,
    from: "players_career_pitching_stats.csv",
    composite_key: [:year, :team_id, :player_id, :split_id]

  pitching_schema "players_career_pitching_stats" do
    field :inherited_runners, :integer
    field :inherited_runners_scored, :integer
    field :inherited_runners_scored_percentage, :float
    field :leverage_index, :float
    field :split_id, :integer
    field :win_probabilty_added, :float
    field :wins_above_replacement, :float

    belongs_to :player, Players.Player
  end
end
