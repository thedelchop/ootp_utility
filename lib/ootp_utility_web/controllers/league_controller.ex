defmodule OOTPUtilityWeb.LeagueController do
  use OOTPUtilityWeb, :controller

  alias OOTPUtility.Leagues

  def index(conn, _params) do
    leagues = Leagues.list_leagues()
    render(conn, "index.html", leagues: leagues)
  end

  def show(conn, %{"id" => id}) do
    league = Leagues.get_league!(id)
    render(conn, "show.html", league: league)
  end
end
