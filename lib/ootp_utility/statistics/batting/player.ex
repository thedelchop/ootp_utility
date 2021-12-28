defmodule OOTPUtility.Statistics.Batting.Player do
  alias OOTPUtility.Statistics.Batting.Player

  @derive {Inspect,
           only: [
             :id,
             :player,
             :team,
             :year,
             :at_bats,
             :hits,
             :home_runs,
             :runs_batted_in,
             :batting_average,
             :on_base_plus_slugging
           ]}

  use Player.Schema,
    composite_key: [:year, :player_id, :team_id, :level, :split_id]

  player_batting_schema "players_career_batting_stats" do
    field :wins_above_replacement, :float
    field :split_id, :integer
    field :pitches_seen, :integer
  end
end
