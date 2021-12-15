defmodule OOTPUtilityWeb.Components.Team.Roster.Hitters do
  @moduledoc """
  A component to represent a leaderboard for a parent, which could
  be a league, conference, division, team, etc..
  """

  use Surface.LiveComponent

  alias OOTPUtilityWeb.Components.Shared.Table
  alias OOTPUtilityWeb.Components.Shared.Table.Column
  alias OOTPUtility.{Players, Statistics}

  prop title, :string, required: true
  prop players, :list, required: true
  prop year, :integer, required: true
  data players_with_statistics, :list, default: []

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
    statistics = Statistics.Batting.for_player(assigns.players, assigns.year)

    players_with_statistics =
      assigns.players
      |> Enum.sort_by(& &1.id)
      |> Enum.zip(statistics)

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
      <div class="p-8 border-b border-gray-200">
        <h2 class={"mb-4"}>{@title}</h2>
        <Table id={table_id(@title)} data={ {hitter, stats} <- @players_with_statistics } header_class={&header_class/2} column_class={&column_class/2}>
          <Column label="#">
            {hitter.uniform_number}
          </Column>

          <Column label="Name">
            {Players.name(hitter, :full)}
          </Column>

          <Column label="B">
            {hitter.bats |> String.first() |> String.capitalize()}
          </Column>

          <Column label="G">
            {stats.games}
          </Column>

          <Column label="AB">
            {stats.at_bats}
          </Column>

          <Column label="H">
            {stats.hits}
          </Column>

          <Column label="HR">
            {stats.home_runs}
          </Column>

          <Column label="RBI">
            {stats.runs_batted_in}
          </Column>

          <Column label="R">
            {stats.runs}
          </Column>

          <Column label="BB">
            {stats.walks}
          </Column>

          <Column label="K">
            {stats.strikeouts}
          </Column>

          <Column label="AVG">
            {stats.batting_average |> :erlang.float_to_binary(decimals: 3) |> String.trim_leading("0")}
          </Column>

          <Column label="OBP">
            {stats.on_base_percentage |> :erlang.float_to_binary(decimals: 3) |> String.trim_leading("0")}
          </Column>

          <Column label="SLG">
            {stats.slugging |> :erlang.float_to_binary(decimals: 3) |> String.trim_leading("0")}
          </Column>

          <Column label="WAR">
            {stats.wins_above_replacement |> :erlang.float_to_binary(decimals: 1)}
          </Column>
        </Table>
      </div>
    """
  end

  def header_class(_col, _index),
    do: do_header_class(["text-right", "font-medium", "text-gray-500"])

  def do_header_class(extra_classes \\ []) do
    Enum.join(extra_classes ++ @default_header_classes, " ")
  end

  def column_class(_standing, _index),
    do: do_column_class(["text-sm", "text-gray-500", "text-right"])

  defp do_column_class(extra_classes \\ []) do
    Enum.join(extra_classes ++ @default_column_classes, " ")
  end
end