defmodule OOTPUtility.Statistics.Pitching.Player do
  alias OOTPUtility.Statistics.Pitching.Player

  @derive {Inspect,
           only: [
             :id,
             :player,
             :team,
             :year,
             :wins,
             :losses,
             :saves,
             :runs,
             :earned_runs,
             :hits,
             :walks,
             :strikeouts,
             :home_runs,
             :earned_run_average,
             :outs_pitched
           ]}

  use Player.Schema,
    composite_key: [:year, :team_id, :player_id, :split]

  player_pitching_schema "players_career_pitching_stats" do
    field :wins_above_replacement, :float
  end
end
