defmodule OOTPUtilityWeb.ConferenceController do
  use OOTPUtilityWeb, :controller

  alias OOTPUtility.{Leagues, Standings}

  def index(conn, _params) do
    conferences = Leagues.list_conferences()
    render(conn, "index.html", conferences: conferences)
  end

  def show(conn, %{"id" => slug}) do
    conference = Leagues.get_conference!(slug)

    standings = Standings.for_conference(conference)

    render(conn, "show.html", conference: conference, standings: standings)
  end
end
