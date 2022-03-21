defmodule OOTPUtilityWeb.Components.Statistics.Leaderboard do
  @moduledoc """
  A component to represent a leaderboard for a parent, which could
  be a league, conference, division, team, etc..
  """
  use Surface.Component

  alias OOTPUtilityWeb.Components.Statistics.Leaderboard.Leader
  alias OOTPUtility.Statistics.Leaderboard

  prop leaders, :list, default: []

  def render(assigns) do
    ~F"""
    <ul class="pt-4 border-b">
      {#for %Leaderboard{statistic: statistic, leaders: [leader | _rest]} <- @leaders}
        <Leader {=leader} {=statistic} />
      {/for}
    </ul>
    """
  end
end
