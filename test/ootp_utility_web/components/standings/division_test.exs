defmodule OOTPUtilityWeb.Components.Standings.DivisionTest do
  use OOTPUtilityWeb.ComponentCase, async: true

  alias OOTPUtility.Repo
  alias OOTPUtilityWeb.Components.Standings.Division, as: DivisionStandings

  test_snapshot "renders its team standings if the division belongs to a league" do
    league = insert(:league, name: "Major League Baseball")
    division = insert(:division, name: "AL East", league: league, conference: nil)

    insert(:team,
      name: "Boston",
      nickname: "Red Sox",
      league: league,
      conference: nil,
      division: division
    )
    |> with_record(%{
      games: 10,
      wins: 5
    })

    insert(:team,
      name: "New York",
      nickname: "Yankees",
      league: league,
      conference: nil,
      division: division
    )
    |> with_record(%{
      games: 10,
      wins: 7
    })

    insert(:team,
      name: "Tampa Bay",
      nickname: "Rays",
      league: league,
      conference: nil,
      division: division
    )
    |> with_record(%{
      games: 10,
      wins: 8
    })

    division = Repo.preload(division, teams: [:record])

    render_surface do
      ~F"""
        <DivisionStandings id={"#{division.slug}-standings"} division={division} />
      """
    end
  end

  test_snapshot "renders its team standings if the division belongs to a conference" do
    league = insert(:league, name: "Major League Baseball")
    conference = insert(:conference, name: "American League")
    division = insert(:division, name: "AL East", league: league, conference: conference)

    insert(:team,
      name: "Boston",
      nickname: "Red Sox",
      league: league,
      conference: conference,
      division: division
    )
    |> with_record(%{
      games: 10,
      wins: 5
    })

    insert(:team,
      name: "New York",
      nickname: "Yankees",
      league: league,
      conference: conference,
      division: division
    )
    |> with_record(%{
      games: 10,
      wins: 7
    })

    insert(:team,
      name: "Tampa Bay",
      nickname: "Rays",
      league: league,
      conference: conference,
      division: division
    )
    |> with_record(%{
      games: 10,
      wins: 8
    })

    division = Repo.preload(division, teams: [:record])

    render_surface do
      ~F"""
        <DivisionStandings id={"#{division.slug}-standings"} division={division} />
      """
    end
  end
end
