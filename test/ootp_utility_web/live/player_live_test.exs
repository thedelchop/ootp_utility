defmodule OOTPUtilityWeb.PlayerLiveTest do
  use OOTPUtilityWeb.ConnCase

  import Phoenix.LiveViewTest
  import OOTPUtility.Factory

  setup do
    insert(:player, first_name: "Babe", last_name: "Ruth", position: :first_base)
    |> with_attributes(
      contact: 150,
      gap_power: 135,
      home_run_power: 175,
      eye: 80,
      avoid_strikeouts: 25
    )
    |> with_attributes(
      infield_range: 70,
      infield_error: 125,
      infield_arm: 54,
      turn_double_play: 43
    )
    |> with_attributes(outfield_range: 23, outfield_error: 10, outfield_arm: 44)
    |> with_attributes(catcher_arm: 48, catcher_ability: 1)
    |> with_attributes(sacrifice_bunt: 100, bunt_for_hit: 32)
    |> with_attributes(speed: 100, stealing: 143, baserunning: 187)
    |> with_positions(first_base: 158, left_field: 137)

    :ok
  end

  test "it renders the string 'I am a player'", %{conn: conn} do
    conn = get(conn, "/players/babe-ruth")

    {:ok, _view, html} = live(conn)

    assert html =~ "Babe Ruth"
  end

  test "it renders requests from the `players` path with the PlayerLive module", %{conn: conn} do
    conn = get(conn, "/players/babe-ruth")

    {:ok, view, _html} = live(conn)

    assert view.module == OOTPUtilityWeb.PlayerLive
  end
end
