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

  data pitchers, :list, default: []
  data catchers, :list, default: []
  data infielders, :list, default: []
  data outfielders, :list, default: []

  @default_column_classes [
    "px-3",
    "py-2",
    "lg:px-6",
    "lg:py-4",
    "whitespace-nowrap"
  ]

  @default_header_classes [
    "px-3",
    "py-1",
    "lg:px-6",
    "lg:py-3",
    "text-xs",
    "uppercase",
    "tracking-wider"
  ]

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
       year: assigns.year
     )}
  end

  def render(assigns) do
    ~F"""
      <div class={"flex", "flex-col", "space-y-5"}>
        <Roster.Pitchers id="pitchers-roster" players={@pitchers} year={@year} title="Pitchers"/>
        <Roster.Hitters id="catchers-roster" players={@catchers} year={@year} title="Catchers"/>
        <Roster.Hitters id="infielders-roster" players={@infielders} year={@year} title="Infielders"/>
        <Roster.Hitters id="outfielders-roster" players={@outfielders} year={@year} title="Outfielders"/>
      </div>
    """
  end

  def header_class(_col, 0),
    do: do_header_class(["w-1/3", "text-left", "font-bold", "text-gray-900"])

  def header_class(_col, 5),
    do: do_header_class(["text-right", "font-medium", "text-gray-500", "hidden", "lg:table-cell"])

  def header_class(_col, _index),
    do: do_header_class(["text-right", "font-medium", "text-gray-500"])

  def do_header_class(extra_classes \\ []) do
    Enum.join(extra_classes ++ @default_header_classes, " ")
  end

  def column_class(_standing, 0), do: do_column_class()

  def column_class(_standing, 5),
    do: do_column_class(["text-sm", "text-gray-500", "text-right", "hidden", "lg:table-cell"])

  def column_class(_standing, _index),
    do: do_column_class(["text-sm", "text-gray-500", "text-right"])

  defp do_column_class(extra_classes \\ []) do
    Enum.join(extra_classes ++ @default_column_classes, " ")
  end
end
