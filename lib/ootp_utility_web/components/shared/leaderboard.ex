defmodule OOTPUtilityWeb.Components.Shared.Leaderboard do
  @moduledoc """
  A component to represent a leaderboard for a parent, which could
  be a league, conference, division, team, etc..
  """
  use Surface.Component

  alias OOTPUtilityWeb.Components.Shared.Leaderboard.Leaders

  prop leaders, :list, default: []
  prop title, :string, default: "Leaderboard"

  def render(assigns) do
    ~F"""
    <div class="batting-leaders">
      <h2>{@title}</h2>
      <div>
        {#for category_leader <- @leaders}
          <Leaders leaders={category_leader} />
        {/for}
      </div>
    </div>
    """
  end
end
