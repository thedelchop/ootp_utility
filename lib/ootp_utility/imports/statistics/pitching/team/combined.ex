defmodule OOTPUtility.Imports.Statistics.Pitching.Team.Combined do
  alias OOTPUtility.Imports.Statistics.Pitching

  use Pitching.Team,
    from: "team_pitching_stats",
    schema: OOTPUtility.Statistics.Pitching.Team
end
