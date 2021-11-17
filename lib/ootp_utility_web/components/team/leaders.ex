defmodule OOTPUtilityWeb.Components.Team.Leaders do
  @moduledoc """
  A component to represent a leaderboard for a parent, which could
  be a league, conference, division, team, etc..
  """

  use Surface.LiveComponent

  alias OOTPUtility.Statistics
  alias OOTPUtilityWeb.Components.Shared.{Leaderboard, Tabs}
  alias OOTPUtilityWeb.Components.Shared.Tabs.Tab

  alias Surface.Components.LiveRedirect

  prop team, :struct, required: true

  def render(assigns) do
    ~F"""
      <div class="bg-white overflow-hidden shadow rounded-lg divide-y divide-gray-200">
        <h1>Team Leaders</h1>
        <hr />
        <Tabs id="team_leaders">
          <Tab label="Hitting">
            <Leaderboard leaders={batting_leaders(@team)} />
          </Tab>
          <Tab label="Pitching">
            <Leaderboard leaders={pitching_leaders(@team)} />
          </Tab>
        </Tabs>
        <hr />
        <LiveRedirect to="#">Sortable Stats</LiveRedirect>
      </div>
    """
  end

  defp batting_leaders(team) do
    [
      {"batting average", Statistics.team_leaders(team, :batting_average)},
      {"home runs", Statistics.team_leaders(team, :home_runs)},
      {"runs batted in", Statistics.team_leaders(team, :runs_batted_in)},
      {"runs", Statistics.team_leaders(team, :runs)},
      {"stolen bases", Statistics.team_leaders(team, :stolen_bases)}
    ]
  end

  defp pitching_leaders(team) do
    [
      {"wins", Statistics.team_leaders(team, :wins)},
      {"saves", Statistics.team_leaders(team, :saves)},
      {"earned_run_average", Statistics.team_leaders(team, :earned_run_average)},
      {"strikeouts", Statistics.team_leaders(team, :strikeouts)},
      {"whip", Statistics.team_leaders(team, :walks_hits_per_inning_pitched)}
    ]
  end
end
