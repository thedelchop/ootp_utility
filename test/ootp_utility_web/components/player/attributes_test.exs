defmodule OOTPUtilityWeb.Components.Player.AttributesTest do
  use OOTPUtilityWeb.ComponentCase, async: true

  alias OOTPUtilityWeb.Components.Player.Attributes

  import OOTPUtility.Factory

  test_snapshot "renders the batting ratings for the specified hitter" do
    player =
      insert(:player, position: :first_base)
      |> with_attributes(
        contact: 150,
        gap_power: 135,
        home_run_power: 175,
        eye: 80,
        avoid_strikeouts: 25,
        infield_range: 100,
        infield_error: 100,
        infield_arm: 100,
        turn_double_play: 100,
        outfield_range: 100,
        outfield_error: 100,
        outfield_arm: 100,
        catcher_arm: 100,
        catcher_ability: 100,
        sacrifice_bunt: 100,
        bunt_for_hit: 100,
        speed: 100,
        stealing: 100,
        baserunning: 100
      )
      |> with_positions(
        first_base: 150,
        left_field: 100
      )

    render_surface do
      ~F"""
      <Attributes id="player-attributes" player={player} />
      """
    end
  end

  test_snapshot "renders the pitching ratings for the specified pitcher" do
    player =
      insert(:player,
        stamina: 150,
        hold_runners: 100,
        velocity: "94-96 MPH",
        groundball_flyball_ratio: "neutral",
        position: :starting_pitcher
      )
      |> with_attributes(
        stuff: 150,
        movement: 135,
        control: 80,
        sacrifice_bunt: 100,
        bunt_for_hit: 100,
        speed: 100,
        stealing: 100,
        baserunning: 100
      )
      |> with_positions(pitcher: 150)
      |> with_pitches(fastball: 175, curveball: 100, slider: 125)

    render_surface do
      ~F"""
      <Attributes id="player-attributes" player={player} />
      """
    end
  end
end
