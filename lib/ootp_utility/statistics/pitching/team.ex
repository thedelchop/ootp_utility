defmodule OOTPUtility.Statistics.Pitching.Team do
  alias __MODULE__

  use Team.Schema, table: "team_pitching_stats"

  defmodule Starters do
    alias OOTPUtility.Statistics.Pitching.Team

    use Team.Schema, table: "team_starting_pitching_stats"
  end

  defmodule Bullpen do
    alias OOTPUtility.Statistics.Pitching.Team

    use Team.Schema, table: "team_bullpen_pitching_stats"
  end
end
