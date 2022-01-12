defmodule OOTPUtilityWeb.Components.Standings.ConferenceTest do
  use OOTPUtilityWeb.ComponentCase, async: true

  alias OOTPUtility.Repo
  alias OOTPUtilityWeb.Components.Standings.Conference, as: ConferenceStandings

  setup do
    league = insert(:league, name: "Major League Baseball")
    conference = insert(:conference, name: "American League", league: league)

    {:ok, league: league, conference: conference}
  end

  test_snapshot "renders all of its division standings if the conference has divisions", %{
    conference: conference,
    league: league
  } do
    american_league_east = insert(:division, name: "AL East", conference: conference, league: league)

    insert(:team,
      name: "Boston",
      nickname: "Red Sox",
      league: league,
      conference: conference,
      division: american_league_east
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
      division: american_league_east
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
      division: american_league_east
    )
    |> with_record(%{
      games: 10,
      wins: 8
    })

    national_league_east = insert(:division, name: "National League East", conference: conference, league: league)

    insert(:team,
      name: "Atlanta",
      nickname: "Braves",
      league: league,
      conference: conference,
      division: national_league_east
    )
    |> with_record(%{
      games: 10,
      wins: 5
    })

    insert(:team,
      name: "New York",
      nickname: "Mets",
      league: league,
      conference: conference,
      division: national_league_east
    )
    |> with_record(%{
      games: 10,
      wins: 7
    })

    insert(:team,
      name: "Florida",
      nickname: "Marlins",
      league: league,
      conference: conference,
      division: national_league_east
    )
    |> with_record(%{
      games: 10,
      wins: 3
    })

    conference = Repo.preload(conference, divisions: [:league, :conference, teams: [:record]])

    render_surface do
      ~F"""
        <ConferenceStandings id={"#{conference.slug}-standings"} conference={conference} />
      """
    end
  end

  test_snapshot "renders its team standings if the conference has no divisions", %{
    conference: conference,
    league: league
  } do
    insert(:team,
      name: "Boston",
      nickname: "Red Sox",
      league: league,
      conference: conference,
      division: nil
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
      division: nil
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
      division: nil
    )
    |> with_record(%{
      games: 10,
      wins: 8
    })

    conference = Repo.preload(conference, [:divisions, teams: [:record]])

    render_surface do
      ~F"""
        <ConferenceStandings id={"#{conference.slug}-standings"} conference={conference} />
      """
    end
  end
end
