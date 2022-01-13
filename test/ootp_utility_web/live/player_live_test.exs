defmodule OOTPUtilityWeb.PlayerLiveTest do
  use OOTPUtilityWeb.ConnCase

  import Phoenix.LiveViewTest

  test "it renders the string 'I am a player'", %{conn: conn} do
    conn = get(conn, "/players/babe-ruth")

    {:ok, _view, html} = live(conn)

    assert html =~ "I am a player"
  end

  test "it renders requests from the `players` path with the PlayerLive module", %{conn: conn} do
    conn = get(conn, "/players/babe-ruth")

    {:ok, view, _html} = live(conn)

    assert view.module == OOTPUtilityWeb.PlayerLive
  end
end
