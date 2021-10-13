defmodule OOTPUtilityWeb.StandingsView do
  use OOTPUtilityWeb, :view

  alias OOTPUtility.{Leagues, Standings}
  alias __MODULE__

  def winning_percentage(%Standings.Team{winning_percentage: pct} = _standing) do
    pct
    |> :erlang.float_to_binary(decimals: 3)
    |> String.trim_leading("0")
  end

  def streak(%Standings.Team{streak: streak} = _standing) when streak > 0, do: "W#{streak}"

  def streak(%Standings.Team{streak: streak} = _standing), do: "L#{abs(streak)}"

  def name(%Standings.League{league: league}), do: league.name
  def name(%Standings.Conference{conference: conference}), do: conference.name
  def name(%Standings.Division{division: division}), do: division.name
  def name(%Standings.Team{}), do: ""

  def abbr(%Standings.League{league: league}), do: league.abbr
  def abbr(%Standings.Conference{conference: conference}), do: conference.abbr

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
    |> Enum.map(&render(StandingsView, "division.html", conn: conn, standings: &1))
    |> Enum.map(&Phoenix.HTML.Safe.to_iodata/1)
    |> raw()
  end

  def child_standings(
        %Standings.League{conference_standings: standings} = _standing,
        conn
      ) do
    standings
    |> Enum.map(&render(StandingsView, "conference.html", conn: conn, standings: &1))
    |> Enum.map(&Phoenix.HTML.Safe.to_iodata/1)
    |> raw()
  end

  def child_standings(
        %Standings.Conference{division_standings: []} = standings,
        conn
      ) do
    render(StandingsView, "teams.html", conn: conn, standings: standings)
    |> Phoenix.HTML.Safe.to_iodata()
    |> raw()
  end

  def child_standings(
        %Standings.Conference{division_standings: standings} = _standing,
        conn
      ) do
    standings
    |> Enum.map(&render(StandingsView, "division.html", conn: conn, standings: &1))
    |> Enum.map(&Phoenix.HTML.Safe.to_iodata/1)
    |> raw()
  end

  def link_to_parent(%Standings.League{league: league} = _standings, conn, do: block) do
    link(to: parent_path(league, conn), do: block)
  end

  def link_to_parent(%Standings.Conference{conference: conference} = _standings, conn, do: block) do
    link(to: parent_path(conference, conn), do: block)
  end

  def link_to_parent(%Standings.Division{division: division} = _standings, conn, do: block) do
    link(to: parent_path(division, conn), do: block)
  end

  def link_to_parent(_, _) do
    ""
  end

  defp parent_path(%Leagues.League{slug: slug} = _league, conn) do
    Routes.league_path(conn, :show, slug)
  end

  defp parent_path(
         %Leagues.Conference{
           league: %Leagues.League{
             slug: league_slug
           },
           slug: slug
         } = _conference,
         conn
       ) do
    Routes.league_conference_path(conn, :show, league_slug, slug)
  end

  defp parent_path(
         %Leagues.Division{
           conference: nil,
           league: %Leagues.League{slug: league_slug},
           slug: slug
         } = _division,
         conn
       ) do
    Routes.league_division_path(conn, :show, league_slug, slug)
  end

  defp parent_path(
         %Leagues.Division{
           conference: %Leagues.Conference{slug: conference_slug},
           league: %Leagues.League{slug: league_slug},
           slug: slug
         } = _division,
         conn
       ) do
    Routes.league_conference_division_path(conn, :show, league_slug, conference_slug, slug)
  end
end
