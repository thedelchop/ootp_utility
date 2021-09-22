defmodule OOTPUtility.Statistics.Pitching.Team do
  alias __MODULE__

  use Team.Schema, from: "team_pitching_stats.csv", to: "team_pitching_stats"

  defmodule Starters do
    alias OOTPUtility.Statistics.Pitching.Team

    use Team.Schema, from: "team_starting_pitching_stats.csv", to: "team_starting_pitching_stats"
  end

  defmodule Bullpen do
    alias OOTPUtility.Statistics.Pitching.Team

    use Team.Schema, from: "team_bullpen_pitching_stats.csv", to: "team_bullpen_pitching_stats"
  end
end
