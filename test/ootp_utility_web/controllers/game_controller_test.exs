defmodule OOTPUtilityWeb.GameControllerTest do
  use OOTPUtilityWeb.ConnCase

  import OOTPUtility.Factory

  describe "index" do
    test "lists all games", %{conn: conn} do
      conn = get(conn, Routes.game_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Games"
    end
  end

  describe "show" do
    test "renders the division for viewing", %{conn: conn} do
      game = insert(:game)
      conn = get(conn, Routes.game_path(conn, :show, game))

      assert html_response(conn, 200) =~ "Show Game"
    end
  end
end
