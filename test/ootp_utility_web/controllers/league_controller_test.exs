defmodule OOTPUtilityWeb.LeagueControllerTest do
  use OOTPUtilityWeb.ConnCase

  import OOTPUtility.LeaguesFixtures

  @create_attrs %{abbr: "some abbr", current_date: ~D[2021-09-05], league_level: "some league_level", logo_filename: "some logo_filename", name: "some name", season_year: 42, start_date: ~D[2021-09-05]}
  @update_attrs %{abbr: "some updated abbr", current_date: ~D[2021-09-06], league_level: "some updated league_level", logo_filename: "some updated logo_filename", name: "some updated name", season_year: 43, start_date: ~D[2021-09-06]}
  @invalid_attrs %{abbr: nil, current_date: nil, league_level: nil, logo_filename: nil, name: nil, season_year: nil, start_date: nil}

  describe "index" do
    test "lists all leagues", %{conn: conn} do
      conn = get(conn, Routes.league_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Leagues"
    end
  end

  describe "new league" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.league_path(conn, :new))
      assert html_response(conn, 200) =~ "New League"
    end
  end

  describe "create league" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.league_path(conn, :create), league: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.league_path(conn, :show, id)

      conn = get(conn, Routes.league_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show League"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.league_path(conn, :create), league: @invalid_attrs)
      assert html_response(conn, 200) =~ "New League"
    end
  end

  describe "edit league" do
    setup [:create_league]

    test "renders form for editing chosen league", %{conn: conn, league: league} do
      conn = get(conn, Routes.league_path(conn, :edit, league))
      assert html_response(conn, 200) =~ "Edit League"
    end
  end

  describe "update league" do
    setup [:create_league]

    test "redirects when data is valid", %{conn: conn, league: league} do
      conn = put(conn, Routes.league_path(conn, :update, league), league: @update_attrs)
      assert redirected_to(conn) == Routes.league_path(conn, :show, league)

      conn = get(conn, Routes.league_path(conn, :show, league))
      assert html_response(conn, 200) =~ "some updated abbr"
    end

    test "renders errors when data is invalid", %{conn: conn, league: league} do
      conn = put(conn, Routes.league_path(conn, :update, league), league: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit League"
    end
  end

  describe "delete league" do
    setup [:create_league]

    test "deletes chosen league", %{conn: conn, league: league} do
      conn = delete(conn, Routes.league_path(conn, :delete, league))
      assert redirected_to(conn) == Routes.league_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.league_path(conn, :show, league))
      end
    end
  end

  defp create_league(_) do
    league = league_fixture()
    %{league: league}
  end
end
