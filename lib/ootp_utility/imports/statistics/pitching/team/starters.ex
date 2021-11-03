defmodule OOTPUtility.Imports.Statistics.Pitching.Team.Starters do
  alias OOTPUtility.Imports.Statistics.Pitching
  alias OOTPUtility.Statistics.Pitching.Team

  use Pitching.Team, from: "team_starting_pitching_stats", schema: Team.Starters
end
