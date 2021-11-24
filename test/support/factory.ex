defmodule OOTPUtility.Factory do
  use ExMachina.Ecto, repo: OOTPUtility.Repo

  use OOTPUtility.GameFactory
  use OOTPUtility.LeagueFactory
  use OOTPUtility.ConferenceFactory
  use OOTPUtility.DivisionFactory
  use OOTPUtility.TeamFactory
  use OOTPUtility.PlayerFactory
  use OOTPUtility.StandingsFactory
end
