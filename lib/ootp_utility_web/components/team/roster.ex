defmodule OOTPUtilityWeb.Components.Team.Roster do
  @moduledoc """
  A component to represent a leaderboard for a parent, which could
  be a league, conference, division, team, etc..
  """

  use Surface.LiveComponent

  alias OOTPUtilityWeb.Components.Team.Roster
  alias OOTPUtilityWeb.Components.Shared.SectionHeader
  alias OOTPUtility.Players

  prop team, :struct
  prop year, :integer
  prop class, :css_class, default: []

  data pitchers, :list, default: []
  data catchers, :list, default: []
  data infielders, :list, default: []
  data outfielders, :list, default: []

  def update(assigns, socket) do
    pitchers = Players.for_team(assigns.team, position: "P")
    catchers = Players.for_team(assigns.team, position: "C")
    infielders = Players.for_team(assigns.team, position: "IF")
    outfielders = Players.for_team(assigns.team, position: "OF")

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
    ["flex", "flex-col"] ++ extra_classes
  end

  def render(assigns) do
    ~F"""
      <div class={container_class(@class)}>
        <SectionHeader>Team Roster</SectionHeader>
        <div class={"flex flex-col space-y-8"}>
          <Roster.Pitchers id="pitchers-roster" players={@pitchers} year={@year} title="Pitchers"/>
          <Roster.Hitters id="catchers-roster" players={@catchers} year={@year} title="Catchers"/>
          <Roster.Hitters id="infielders-roster" players={@infielders} year={@year} title="Infielders"/>
          <Roster.Hitters id="outfielders-roster" players={@outfielders} year={@year} title="Outfielders"/>
        </div>
      </div>
    """
  end
end
