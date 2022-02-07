defmodule OOTPUtilityWeb.Components.Player.AttributesTest do
  use OOTPUtilityWeb.ComponentCase, async: true

  alias OOTPUtilityWeb.Components.Player.Attributes

  test_snapshot "renders a header for the specified player" do
    player =
      insert(:player)
      |> with_batting_ratings()

    render_surface do
      ~F"""
        <Attributes id={"player-header"} player={player} />
      """
    end
  end
end
