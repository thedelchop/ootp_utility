defmodule OOTPUtilityWeb.Components.Team.Leaders do
  @moduledoc """
  A component to represent a leaderboard for a parent, which could
  be a league, conference, division, team, etc..
  """

  use Surface.LiveComponent

  alias OOTPUtility.Statistics
  alias OOTPUtilityWeb.Components.Shared.{SectionHeader, Tabs}
  alias OOTPUtilityWeb.Components.Shared.Tabs.Tab
  alias OOTPUtilityWeb.Components.Statistics.Leaderboard

  alias Surface.Components.LiveRedirect

  prop team, :struct, required: true

  def render(assigns) do
    ~F"""
      <div class="bg-white overflow-hidden shadow rounded-lg divide-y divide-gray-200 p-4">
        <SectionHeader>Team Leaders</SectionHeader>
        <Tabs id="team_leaders">
          <Tab label="Hitting">
            <Leaderboard leaders={batting_leaders(@team)} />
          </Tab>
          <Tab label="Pitching">
            <Leaderboard leaders={pitching_leaders(@team)} />
          </Tab>
        </Tabs>
        <LiveRedirect class="border-none" to="#">Sortable Stats</LiveRedirect>
      </div>
    """
  end

  defp batting_leaders(team) do
    [
      Statistics.team_leaders(team, :batting_average),
      Statistics.team_leaders(team, :home_runs),
      Statistics.team_leaders(team, :runs_batted_in),
      Statistics.team_leaders(team, :runs),
      Statistics.team_leaders(team, :stolen_bases)
    ]
  end

  defp pitching_leaders(team) do
    [
      Statistics.team_leaders(team, :wins),
      Statistics.team_leaders(team, :saves),
      Statistics.team_leaders(team, :earned_run_average),
      Statistics.team_leaders(team, :strikeouts),
      Statistics.team_leaders(team, :walks_hits_per_inning_pitched)
    ]
  end
end
