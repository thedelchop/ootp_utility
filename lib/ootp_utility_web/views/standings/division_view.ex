defmodule OOTPUtilityWeb.Standings.DivisionView do
  use OOTPUtilityWeb.StandingsView

  alias OOTPUtility.{Leagues, Standings}

  def child_standings(
        %Standings.Division{team_standings: standings} = _standing,
        conn
      ) do
    standings
    |> Enum.map(&render(TeamView, "team.html", conn: conn, team: &1))
    |> Enum.map(&Phoenix.HTML.Safe.to_iodata/1)
    |> raw()
  end

  def name(%Standings.Division{division: division}), do: division.name

  def link_to_parent(%Standings.Division{division: division} = _standings, conn, do: block) do
    link(to: parent_path(division, conn), do: block)
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
