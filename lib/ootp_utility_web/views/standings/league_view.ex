defmodule OOTPUtilityWeb.Standings.LeagueView do
  use OOTPUtilityWeb.StandingsView

  def container_name(%Standings.League{league: league}), do: league.name

  def abbr(%Standings.League{league: league}), do: league.abbr

  def league_container_classes(
        %Standings.League{conference_standings: conf_standings} = standings
      )
      when length(conf_standings) > 1 do
    league_container_classes(standings, "xl:grid-cols-2 xl:gap-4")
  end

  def league_container_classes(%Standings.League{} = _standings, extra_classes \\ "") do
    default_classes = "grid sm:grid-cols-1 py-6 px-3"

    [class: Enum.join([default_classes, extra_classes], " ")]
  end

  def child_standings(
        %Standings.League{conference_standings: [], division_standings: standings} = _standing,
        conn
      ) do
    standings
    |> Enum.map(&render(DivisionView, "division.html", conn: conn, standings: &1))
    |> Enum.map(&Phoenix.HTML.Safe.to_iodata/1)
    |> raw()
  end

  def child_standings(
        %Standings.League{conference_standings: standings} = _standing,
        conn
      ) do
    standings
    |> Enum.map(&render(ConferenceView, "conference.html", conn: conn, standings: &1))
    |> Enum.map(&Phoenix.HTML.Safe.to_iodata/1)
    |> raw()
  end

  def link_to_parent(%Standings.League{league: league} = _standings, conn, do: block) do
    link(to: parent_path(league, conn), do: block)
  end

  defp parent_path(%Leagues.League{slug: slug} = _league, conn) do
    Routes.league_path(conn, :show, slug)
  end
end
