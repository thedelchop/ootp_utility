defmodule OOTPUtilityWeb.TeamControllerTest do
  use OOTPUtilityWeb.ConnCase

  import OOTPUtility.TeamsFixtures

  describe "index" do
    test "lists all teams", %{conn: conn} do
      conn = get(conn, Routes.team_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Teams"
    end
  end

  describe "show" do
    setup [:create_team]

    test "renders the division for viewing", %{conn: conn, team: team} do
      conn = get(conn, Routes.team_path(conn, :show, team))
      assert html_response(conn, 200) =~ "Show Team"
    end
  end

  defp create_team(_) do
    %{team: team_fixture()}
  end
end
