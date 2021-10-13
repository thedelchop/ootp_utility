defmodule OOTPUtilityWeb.StandingsView do
  use OOTPUtilityWeb, :view

  alias OOTPUtility.Standings.{Conference, Division, League, Team}
  alias __MODULE__

  def winning_percentage(%Team{winning_percentage: pct} = _standing) do
    pct
    |> :erlang.float_to_binary(decimals: 3)
    |> String.trim_leading("0")
  end

  def streak(%Team{streak: streak} = _standing) when streak > 0, do: "W#{streak}"

  def streak(%Team{streak: streak} = _standing), do: "L#{abs(streak)}"

  def league_container_classes(%League{conference_standings: conf_standings} = standings)
      when length(conf_standings) > 1 do
    league_container_classes(standings, "xl:grid-cols-2 xl:gap-4")
  end

  def league_container_classes(%League{} = _standings, extra_classes \\ "") do
    default_classes = "grid sm:grid-cols-1 py-6 px-3"

    [class: Enum.join([default_classes, extra_classes], " ")]
  end

  def child_standings(
        %League{conference_standings: [], division_standings: standings} = _standing,
        conn
      ) do
    standings
    |> Enum.map(&render(StandingsView, "division.html", conn: conn, standings: &1))
    |> Enum.map(&Phoenix.HTML.Safe.to_iodata/1)
    |> raw()
  end

  def child_standings(
        %League{conference_standings: standings} = _standing,
        conn
      ) do
    standings
    |> Enum.map(&render(StandingsView, "conference.html", conn: conn, standings: &1))
    |> Enum.map(&Phoenix.HTML.Safe.to_iodata/1)
    |> raw()
  end

  def child_standings(
        %Conference{division_standings: []} = standings,
        conn
      ) do
    render(StandingsView, "teams.html", conn: conn, standings: standings)
    |> Phoenix.HTML.Safe.to_iodata()
    |> raw()
  end

  def child_standings(
        %Conference{division_standings: standings} = _standing,
        conn
      ) do
    standings
    |> Enum.map(&render(StandingsView, "division.html", conn: conn, standings: &1))
    |> Enum.map(&Phoenix.HTML.Safe.to_iodata/1)
    |> raw()
  end

  def link_to_parent(%Division{} = standings, conn) do
    link(standings.name, to: Routes.division_path(conn, :show, standings.division_id))
  end

  def link_to_parent(_standings, _conn) do
    ""
  end
end
