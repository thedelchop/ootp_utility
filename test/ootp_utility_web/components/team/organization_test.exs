defmodule OOTPUtilityWeb.Components.Team.OrganizationTest do
  use OOTPUtilityWeb.ComponentCase, async: true

  alias OOTPUtilityWeb.Components.Team.Organization

  test_snapshot "it renders all of the affiliate teams for the organization" do
    organization =
      insert(:team, name: "Boston", nickname: "Red Sox")
      |> as_organization()
      |> add_affiliates()

    render_surface do
      ~F"""
      <Organization id={"#{organization.slug}-organization"} team={organization} />
      """
    end
  end

  defp add_affiliates(organization) do
    with_affiliates(organization, [
      insert(:team,
        level: :triple_a,
        name: "Pawtucket",
        nickname: "Red Sox",
        logo_filename: "pawtucket_red_sox.png"
      )
      |> with_record(%{games: 100, wins: 60, games_behind: 0.0}),
      insert(:team,
        level: :double_a,
        name: "Portland",
        nickname: "Sea Dogs",
        logo_filename: "portland_sea_dogs.png"
      )
      |> with_record(%{games: 92, wins: 54, games_behind: 3.0}),
      insert(:team,
        level: :single_a,
        name: "Greenville",
        nickname: "Drive",
        logo_filename: "greenville_drive.png"
      )
      |> with_record(%{games: 88, wins: 42, games_behind: 5.5}),
      insert(:team,
        level: :low_a,
        name: "Lowell",
        nickname: "Spinners",
        logo_filename: "lowell_spinners.png"
      )
      |> with_record(%{games: 75, wins: 30, games_behind: 15.5}),
      insert(:team,
        level: :rookie,
        name: "Fort Myers",
        nickname: "Red Sox",
        logo_filename: "fort_myers_red_sox.png"
      )
      |> with_record(%{games: 50, wins: 35, games_behind: 0.0})
    ])
  end
end
