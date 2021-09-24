defmodule OOTPUtilityWeb.ConferenceControllerTest do
  use OOTPUtilityWeb.ConnCase

  import OOTPUtility.LeaguesFixtures

  describe "index" do
    test "lists all conferences", %{conn: conn} do
      conn = get(conn, Routes.conference_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Conferences"
    end
  end

  describe "show conference" do
    setup [:create_conference]

    test "renders the conference for viewing", %{conn: conn, conference: conference} do
      conn = get(conn, Routes.conference_path(conn, :show, conference))
      assert html_response(conn, 200) =~ "Show Conference"
    end
  end

  defp create_conference(_) do
    %{conference: conference_fixture()}
  end
end
