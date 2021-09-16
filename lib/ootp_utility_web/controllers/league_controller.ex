defmodule OOTPUtilityWeb.LeagueController do
  use OOTPUtilityWeb, :controller

  alias OOTPUtility.Leagues
  alias OOTPUtility.Standings

  def index(conn, _params) do
    leagues = Leagues.list_leagues()
    render(conn, "index.html", leagues: leagues)
  end

  def show(conn, %{"id" => id}) do
    league = Leagues.get_league!(id)

    standings = Standings.for_league(league)

    render(conn, "show.html", league: league, standings: standings)
  end
end
