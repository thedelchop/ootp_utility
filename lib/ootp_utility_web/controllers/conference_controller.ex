defmodule OOTPUtilityWeb.ConferenceController do
  use OOTPUtilityWeb, :controller

  alias OOTPUtility.Leagues

  def index(conn, _params) do
    conferences = Leagues.list_conferences()
    render(conn, "index.html", conferences: conferences)
  end

  def show(conn, %{"id" => id}) do
    conference = Leagues.get_conference!(id)
    render(conn, "show.html", conference: conference)
  end
end
