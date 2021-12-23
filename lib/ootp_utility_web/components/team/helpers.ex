defmodule OOTPUtilityWeb.Components.Team.Helpers do
  alias OOTPUtility.{Standings, Teams}

  @moduledoc """
  A set of common functions for teams that can be imported into various
  team-related LiveViews to perform common functions

  These include functions such as `get_record`, which instead of return
  the actual %Team.Record{}, this returns the string "90-72".

  ## Examples

    iex> defmodule OOTPUtilityWeb.TeamLive do
           import OOTPUtilityWeb.Components.Team.Helpers
         end
  """

  @doc """
  Returns the record for the Team, as a readable string.

  ## Examples
    iex>  team_record(%Team{})
    "90-72"
  """
  @spec team_record(%Teams.Team{}) :: String.t()
  def team_record(%Teams.Team{} = team) do
    %Standings.TeamRecord{wins: wins, losses: losses} = Standings.for_team(team)

    "#{wins}-#{losses}"
  end

  @spec games_behind(%Teams.Team{}) :: String.t()
  def games_behind(%Teams.Team{} = team) do
    %Standings.TeamRecord{games_behind: games_behind} = Standings.for_team(team)

    "#{games_behind} GB"
  end
end
