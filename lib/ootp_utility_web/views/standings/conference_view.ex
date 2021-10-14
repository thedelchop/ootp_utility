defmodule OOTPUtilityWeb.Standings.ConferenceView do
  use OOTPUtilityWeb.StandingsView

  def container_name(%Standings.Conference{conference: conference}), do: conference.name

  def abbr(%Standings.Conference{conference: conference}), do: conference.abbr

  def child_standings(
        %Standings.Conference{division_standings: []} = standings,
        conn
      ) do
    render(TeamView, "teams.html", conn: conn, standings: standings)
    |> Phoenix.HTML.Safe.to_iodata()
    |> raw()
  end

  def child_standings(
        %Standings.Conference{division_standings: standings} = _standing,
        conn
      ) do
    standings
    |> Enum.map(&render(DivisionView, "division.html", conn: conn, standings: &1))
    |> Enum.map(&Phoenix.HTML.Safe.to_iodata/1)
    |> raw()
  end

  def link_to_parent(%Standings.Conference{conference: conference} = _standings, conn, do: block) do
    link(to: parent_path(conference, conn), do: block)
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
end
