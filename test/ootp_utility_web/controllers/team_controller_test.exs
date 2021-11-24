defmodule OOTPUtilityWeb.TeamControllerTest do
  use OOTPUtilityWeb.ConnCase

  import OOTPUtility.Factory

  describe "index" do
    test "lists all teams", %{conn: conn} do
      conn = get(conn, Routes.team_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Teams"
    end
  end

  describe "show" do
    test "renders the division for viewing", %{conn: conn} do
      team = insert(:team)
      conn = get(conn, Routes.team_path(conn, :show, team))

      assert html_response(conn, 200) =~ team.name
    end
  end
end
