defmodule OOTPUtilityWeb.DivisionController do
  use OOTPUtilityWeb, :controller

  alias OOTPUtility.{Leagues, Standings}

  def index(conn, _params) do
    divisions = Leagues.list_divisions()
    render(conn, "index.html", divisions: divisions)
  end

  def show(conn, %{"id" => slug, "league_id" => league_slug, "conference_id" => conference_slug}) do
    division = Leagues.get_division!(slug, league_slug, conference_slug)
    standings = Standings.for_division(division)

    render(conn, "show.html", division: division, standings: standings)
  end

  def show(conn, %{"id" => slug, "league_id" => league_slug}) do
    division = Leagues.get_division!(slug, league_slug)
    standings = Standings.for_division(division)

    render(conn, "show.html", division: division, standings: standings)
  end
end
