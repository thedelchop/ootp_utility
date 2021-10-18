defmodule OOTPUtilityWeb.GameControllerTest do
  use OOTPUtilityWeb.ConnCase

  import OOTPUtility.GamesFixtures

  describe "index" do
    test "lists all games", %{conn: conn} do
      conn = get(conn, Routes.game_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Games"
    end
  end

  describe "show" do
    setup [:create_game]

    test "renders the division for viewing", %{conn: conn, game: game} do
      conn = get(conn, Routes.game_path(conn, :show, game))
      assert html_response(conn, 200) =~ "Show Game"
    end
  end

  defp create_game(_) do
    %{game: game_fixture()}
  end
end