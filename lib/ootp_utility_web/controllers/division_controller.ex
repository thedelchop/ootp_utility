defmodule OOTPUtilityWeb.DivisionController do
  use OOTPUtilityWeb, :controller

  alias OOTPUtility.{Leagues, Standings}

  def index(conn, _params) do
    divisions = Leagues.list_divisions()
    render(conn, "index.html", divisions: divisions)
  end

  def show(conn, %{"id" => id}) do
    division = Leagues.get_division!(id)
    standings = Standings.for_division(division)

    render(conn, "show.html", division: division, standings: standings)
  end
end
