defmodule OOTPUtilityWeb.LeagueController do
  use OOTPUtilityWeb, :controller

  alias OOTPUtility.{Leagues, Standings}

  def index(conn, _params) do
    leagues = Leagues.list_leagues()
    render(conn, "index.html", leagues: leagues)
  end

  def show(conn, %{"id" => slug}) do
    league = Leagues.get_league!(slug)

    standings = Standings.for_league(league)

    render(conn, "show.html", league: league, standings: standings)
  end
end
