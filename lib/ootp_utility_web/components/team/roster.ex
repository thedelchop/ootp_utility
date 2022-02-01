defmodule OOTPUtilityWeb.Components.Team.Roster do
  @moduledoc """
  A component to represent a leaderboard for a parent, which could
  be a league, conference, division, team, etc..
  """

  use Surface.LiveComponent

  alias OOTPUtilityWeb.Components.Team.Roster
  alias OOTPUtility.Players

  prop team, :struct
  prop year, :integer
  prop class, :css_class, default: []

  data pitchers, :list, default: []
  data catchers, :list, default: []
  data infielders, :list, default: []
  data outfielders, :list, default: []

  def update(assigns, socket) do
    pitchers = Players.for_team(assigns.team, position: "P", roster: :active, order_by: :position)
    catchers = Players.for_team(assigns.team, position: "C", roster: :active, order_by: :position)

    infielders =
      Players.for_team(assigns.team, position: "IF", roster: :active, order_by: :position)

    outfielders =
      Players.for_team(assigns.team, position: "OF", roster: :active, order_by: :position)

    {:ok,
     assign(socket,
       pitchers: pitchers,
       catchers: catchers,
       infielders: infielders,
       outfielders: outfielders,
       year: assigns.year,
       class: assigns.class
     )}
  end

  def container_class(extra_classes) do
    ["flex", "flex-col", "gap-4"] ++ extra_classes
  end

  def render(assigns) do
    ~F"""
      <div class={container_class(@class)}>
        <Roster.Pitchers id="pitchers-roster" players={@pitchers} year={@year} title="Pitchers"/>
        <Roster.Hitters id="catchers-roster" players={@catchers} year={@year} title="Catchers"/>
        <Roster.Hitters id="infielders-roster" players={@infielders} year={@year} title="Infielders"/>
        <Roster.Hitters id="outfielders-roster" players={@outfielders} year={@year} title="Outfielders"/>
      </div>
    """
  end
end
