defmodule OOTPUtilityWeb.Components.Team.Leaders do
  @moduledoc """
  A component to represent a leaderboard for a parent, which could
  be a league, conference, division, team, etc..
  """

  use Surface.LiveComponent

  alias OOTPUtilityWeb.Components.Shared.Leaderboard
  alias Surface.Components.LiveRedirect

  prop batting, :map
  prop pitching, :map

  def render(assigns) do
    ~F"""
      <div class="bg-white overflow-hidden shadow rounded-lg divide-y divide-gray-200">
        <div class="px-4 py-5 sm:px-6">
          <h3>Leaders</h3>
          <!-- We use less vertical padding on card headers on desktop than on body sections -->
        </div>
        <div class="px-4 py-5 sm:p-6">
          <Leaderboard title="Batting" leaders={@batting}/>
          <hr />
          <Leaderboard title="Pitching" leaders={@pitching}/>
        </div>
        <div class="px-4 py-4 sm:px-6">
          <LiveRedirect to="#">Sortable Stats</LiveRedirect>
        </div>
      </div>
    """
  end
end
