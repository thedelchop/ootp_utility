defmodule OOTPUtility.Statistics.Pitching.Team do
  alias __MODULE__

  @derive {Inspect,
           only: [
             :id,
             :team,
             :year,
             :runs,
             :earned_runs,
             :wins,
             :losses,
             :saves,
             :hits,
             :walks,
             :strikeouts,
             :home_runs,
             :earned_run_average
           ]}

  use Team.Schema, table: "team_pitching_stats"

  defmodule Starters do
    alias OOTPUtility.Statistics.Pitching.Team

    @derive {Inspect,
             only: [
               :id,
               :team,
               :year,
               :runs,
               :earned_runs,
               :wins,
               :losses,
               :quality_starts,
               :hits,
               :walks,
               :strikeouts,
               :home_runs,
               :earned_run_average
             ]}

    use Team.Schema, table: "team_starting_pitching_stats"
  end

  defmodule Bullpen do
    alias OOTPUtility.Statistics.Pitching.Team

    @derive {Inspect,
             only: [
               :id,
               :team,
               :year,
               :runs,
               :earned_runs,
               :wins,
               :losses,
               :saves,
               :holds,
               :hits,
               :walks,
               :strikeouts,
               :home_runs,
               :earned_run_average
             ]}

    use Team.Schema, table: "team_bullpen_pitching_stats"
  end
end
