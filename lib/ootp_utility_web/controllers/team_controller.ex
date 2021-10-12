defmodule OOTPUtilityWeb.TeamController do
  use OOTPUtilityWeb, :controller

  alias OOTPUtility.Teams

  def index(conn, _params) do
    teams = Teams.list_teams()
    render(conn, "index.html", teams: teams)
  end

  def show(conn, %{"id" => slug}) do
    team = Teams.get_team_by_slug!(slug)
    render(conn, "show.html", team: team)
  end
end
