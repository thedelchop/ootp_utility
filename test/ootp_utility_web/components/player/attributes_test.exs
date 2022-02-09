defmodule OOTPUtilityWeb.Components.Player.AttributesTest do
  use OOTPUtilityWeb.ComponentCase, async: true

  alias OOTPUtilityWeb.Components.Player.Attributes

  test_snapshot "renders the batting ratings for the specified hitter" do
    player =
      insert(:player, position: :first_base)
      |> with_batting_ratings(contact: 150, gap_power: 135, home_run_power: 175, eye: 80, avoid_strikeouts: 25)

    render_surface do
      ~F"""
        <Attributes id={"player-attributes"} player={player} />
      """
    end
  end

  test_snapshot "renders the pitching ratings for the specified pitcher" do
    player =
      insert(:player, position: :starting_pitcher)
      |> with_pitching_ratings(stuff: 150, movement: 135, control: 80)

    render_surface do
      ~F"""
        <Attributes id={"player-attributes"} player={player} />
      """
    end
  end
end
