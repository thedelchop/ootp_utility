defmodule OOTPUtilityWeb.Components.Shared.Leaderboard do
  @moduledoc """
  A component to represent a leaderboard for a parent, which could
  be a league, conference, division, team, etc..
  """
  use Surface.Component

  alias OOTPUtilityWeb.Components.Shared.Leaderboard.Leader

  prop leaders, :list, default: []

  def render(assigns) do
    ~F"""
      <ul class="pt-4 border-b">
        {#for {statistic, [leader| _rest]} <- @leaders}
          <Leader leader={leader} statistic={statistic} />
        {/for}
      </ul>
    """
  end
end
