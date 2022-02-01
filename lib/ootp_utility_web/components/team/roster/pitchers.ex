defmodule OOTPUtilityWeb.Components.Team.Roster.Pitchers do
  @moduledoc """
  A component to represent a leaderboard for a parent, which could
  be a league, conference, division, team, etc..
  """

  use Surface.LiveComponent

  alias Surface.Components.LiveRedirect

  alias OOTPUtilityWeb.Components.Shared.{SectionHeader, Table}
  alias OOTPUtilityWeb.Components.Shared.Table.Column
  alias OOTPUtilityWeb.PlayerLive
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  alias OOTPUtility.{Players, Statistics}

  import OOTPUtility.Utilities, only: [get_position_key: 1]

  prop title, :string, required: true
  prop players, :list, required: true
  prop year, :integer, required: true
  data players_with_statistics, :list, default: []

  @default_column_classes [
    "px-1",
    "py-2",
    "whitespace-nowrap"
  ]

  @default_header_classes [
    "px-1",
    "py-2",
    "text-xs",
    "uppercase"
  ]

  def update(assigns, socket) do
    statistics = Statistics.Pitching.for_player(assigns.players, assigns.year)

    players_with_statistics =
      assigns.players
      |> Enum.sort_by(& &1.id)
      |> Enum.zip(statistics)
      |> Enum.sort_by(fn
        {pitcher, _stats} -> pitcher.position
      end)
      |> Enum.reverse()

    {:ok, assign(socket, players_with_statistics: players_with_statistics, title: assigns.title)}
  end

  def table_id(title) do
    dasherized_title =
      title
      |> String.split(" ")
      |> Enum.map(&String.downcase/1)
      |> Enum.join("-")

    "#{dasherized_title}-roster-table"
  end

  def render(assigns) do
    ~F"""
      <div class="flex flex-col bg-white p-4 border-b border-gray-200 rounded-md shadow">
        <SectionHeader>{@title}</SectionHeader>
        <div class={"relative block"}>
          <div class={"overflow-x-scroll overflow-y-visible pb-1 ml-32"}>
            <Table id={table_id(@title)} data={{pitcher, stats} <- @players_with_statistics} class={"px-2 py-1 lg:px-4 lg:py-2"} header_class={&header_class/2} column_class={&column_class/2}>
              <Column label={""}>
                <LiveRedirect to={path_to_player(pitcher, @socket)}>
                  <span class="md:hidden">{Players.name(pitcher, :short)}</span>
                  <span class="hidden md:block">{Players.name(pitcher, :full)}</span>
                </LiveRedirect>
              </Column>

            <Column label="Role">
                {get_position_key(pitcher.position)}
              </Column>

              <Column label="T">
                {pitcher.throws |> String.first() |> String.capitalize()}
              </Column>

              <Column label="G">
                {stats.games}
              </Column>

              <Column label="GS">
                {stats.games_started}
              </Column>

              <Column label="IP">
                {stats.losses}
              </Column>

              <Column label="W">
                {stats.wins}
              </Column>

              <Column label="L">
                {stats.losses}
              </Column>

              <Column label="S">
                {stats.saves}
              </Column>

              <Column label="K">
                {stats.strikeouts}
              </Column>

              <Column label="BB">
                {stats.walks}
              </Column>

              <Column label="R">
                {stats.runs}
              </Column>

              <Column label="ERA">
                {stats.earned_run_average |> :erlang.float_to_binary(decimals: 2)}
              </Column>

              <Column label="WHIP">
                {stats.walks_hits_per_inning_pitched |> :erlang.float_to_binary(decimals: 2)}
              </Column>

              <Column label="WAR">
                {stats.wins_above_replacement}
              </Column>
            </Table>
          </div>
        </div>
      </div>
    """
  end

  def header_class(_col, 0),
    do:
      do_header_class([
        "text-left",
        "font-medium",
        "text-gray-500",
        "bg-gray-100",
        "absolute",
        "top-auto",
        "left-0",
        "w-32",
        "h-8"
      ])

  def header_class(_col, 1),
    do: do_header_class(["text-center", "font-medium", "text-gray-500"])

  def header_class(_col, _index),
    do: do_header_class(["text-right", "font-medium", "text-gray-500"])

  def do_header_class(extra_classes \\ []) do
    Enum.join(extra_classes ++ @default_header_classes, " ")
  end

  def column_class(_standing, 0),
    do:
      do_column_class([
        "text-sm",
        "text-gray-500",
        "text-right",
        "absolute",
        "top-auto",
        "left-0",
        "w-32",
        "border-t",
        "-mt-px"
      ])

  def column_class(_standing, 1),
    do: do_column_class(["text-sm", "text-gray-500", "text-center", "border-t"])

  def column_class(_standing, _index),
    do: do_column_class(["text-sm", "text-gray-500", "text-right", "border-t", "tabular-nums"])

  defp do_column_class(extra_classes) do
    Enum.join(extra_classes ++ @default_column_classes, " ")
  end

  defp path_to_player(%Players.Player{slug: slug} = _player, socket),
    do: Routes.live_path(socket, PlayerLive, slug)
end
