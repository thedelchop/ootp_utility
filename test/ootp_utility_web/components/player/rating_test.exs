defmodule OOTPUtilityWeb.Components.Player.RatingTest do
  use OOTPUtilityWeb.ComponentCase, async: true

  alias OOTPUtilityWeb.Components.Player.Rating

  test_snapshot "returns a rating for the player, both ability and talent, as stars" do
    player = build(:player, ability: 65, talent: 71)

    render_surface do
      ~F"""
      <Rating player={player} />
      """
    end
  end
end
