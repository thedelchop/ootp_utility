defmodule OOTPUtilityWeb.DivisionController do
  use OOTPUtilityWeb, :controller

  alias OOTPUtility.Leagues

  def index(conn, _params) do
    divisions = Leagues.list_divisions()
    render(conn, "index.html", divisions: divisions)
  end

  def show(conn, %{"id" => id}) do
    division = Leagues.get_division!(id)
    render(conn, "show.html", division: division)
  end
end
