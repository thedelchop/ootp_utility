defmodule OOTPUtility.Factory do
  use ExMachina.Ecto, repo: OOTPUtility.Repo

  import OOTPUtility.Factories.Utilities

  use OOTPUtility.GameFactory
  use OOTPUtility.LeagueFactory
  use OOTPUtility.ConferenceFactory
  use OOTPUtility.DivisionFactory
  use OOTPUtility.TeamFactory
  use OOTPUtility.PlayerFactory
  use OOTPUtility.StandingsFactory
  use OOTPUtility.Statistics.BattingFactory
  use OOTPUtility.Statistics.PitchingFactory
  use OOTPUtility.Teams.RosterFactory
  use OOTPUtility.Standings.TeamRecordFactory
end
