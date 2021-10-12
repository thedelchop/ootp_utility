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
      %OOTPUtility.Leagues.Division{league: league, conference: conference} =
        OOTPUtility.Repo.preload(division, [:league, :conference])

      conn =
        get(
          conn,
          Routes.division_path(conn, :show, division,
            league_id: league.slug,
            conference_id: conference.slug
          )
        )

      assert html_response(conn, 200) =~ division.name
    end
  end

  defp create_division(_) do
    %{division: division_fixture()}
  end
end
