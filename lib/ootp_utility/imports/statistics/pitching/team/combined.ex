defmodule OOTPUtility.Imports.Statistics.Pitching.Team.Combined do
  alias OOTPUtility.Imports.Statistics.Pitching

  use Pitching.Team,
    from: "team_pitching_stats.csv",
    schema: OOTPUtility.Statistics.Pitching.Team
end
