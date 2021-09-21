defmodule OOTPUtilityWeb.PlayerControllerTest do
  use OOTPUtilityWeb.ConnCase

  import OOTPUtility.{LeaguesFixtures, PlayersFixtures, TeamsFixtures}

  describe "index" do
    setup [:create_player]

    test "lists all players", %{conn: conn, player: player} do
      conn = get(conn, Routes.player_path(conn, :index), team_id: player.team_id)
      assert html_response(conn, 200) =~ "Listing Players"
    end
  end

  describe "show" do
    setup [:create_player]

    test "renders the division for viewing", %{conn: conn, player: player} do
      conn = get(conn, Routes.player_path(conn, :show, player))
      assert html_response(conn, 200) =~ "Show Player"
    end
  end

  defp create_player(_) do
    player =
      league_fixture()
      |> conference_fixture()
      |> division_fixture()
      |> team_fixture()
      |> player_fixture()

    %{player: player}
  end
end
