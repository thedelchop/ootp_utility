defmodule OOTPUtilityWeb.DivisionControllerTest do
  use OOTPUtilityWeb.ConnCase

  import OOTPUtility.LeaguesFixtures

  describe "index" do
    test "lists all divisions", %{conn: conn} do
      conn = get(conn, Routes.division_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Divisions"
    end
  end

  describe "show" do
    setup [:create_division]

    test "renders the division for viewing", %{conn: conn, division: division} do
      conn = get(conn, Routes.division_path(conn, :show, division))
      assert html_response(conn, 200) =~ "Show Division"
    end
  end

  defp create_division(_) do
    %{division: division_fixture()}
  end
end
