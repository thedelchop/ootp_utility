defmodule OOTPUtilityWeb.Components.Player.RatingTest do
  use OOTPUtilityWeb.ComponentCase, async: true

  alias OOTPUtilityWeb.Components.Player.Header

  test_snapshot "renders a header for the specified player" do
    team = insert(:team,
      name: "Boston",
      nickname: "Red Sox",
      logo_filename: "boston_red_sox.png"
    )

    player = insert(:player,
      first_name: "Babe",
      last_name: "Ruth",
      position: "LF",
      uniform_number: 3,
      bats: "left",
      throws: "right",
      height: 184,
      weight: 205,
      date_of_birth: ~D[1983-10-11],
      age: 39,
      ability: 65,
      talent: 71,
      team: team)

    render_surface do
      ~F"""
        <Header id={"player-header"} player={player} />
      """
    end
  end
end
