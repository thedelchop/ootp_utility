defmodule OOTPUtilityWeb.Components.Standings.LeagueTest do
  use OOTPUtilityWeb.ComponentCase, async: true

  alias OOTPUtility.Repo
  alias OOTPUtilityWeb.Components.Standings.League, as: LeagueStandings

  setup do
    league = insert(:league, name: "Major League Baseball")

    {:ok, league: league}
  end

  test_snapshot "renders all of its conference standings if the league has conferences", %{
    league: league
  } do
    american_league = insert(:conference, name: "American League", league: league)

    insert(:team,
      name: "Boston",
      nickname: "Red Sox",
      league: league,
      conference: american_league,
      division: nil
    )
    |> with_record(%{
      games: 100,
      wins: 5
    })

    insert(:team,
      name: "New York",
      nickname: "Yankees",
      league: league,
      conference: american_league,
      division: nil
    )
    |> with_record(%{
      games: 100,
      wins: 7
    })

    insert(:team,
      name: "Tampa Bay",
      nickname: "Rays",
      league: league,
      conference: american_league,
      division: nil
    )
    |> with_record(%{
      games: 100,
      wins: 7
    })

    national_league = insert(:conference, name: "National League", league: league)

    insert(:team,
      name: "Atlanta",
      nickname: "Braves",
      league: league,
      conference: national_league,
      division: nil
    )
    |> with_record(%{
      games: 10,
      wins: 5
    })

    insert(:team,
      name: "New York",
      nickname: "Mets",
      league: league,
      conference: national_league,
      division: nil
    )
    |> with_record(%{
      games: 10,
      wins: 7
    })

    insert(:team,
      name: "Loa Angeles",
      nickname: "Dodgers",
      league: league,
      conference: national_league,
      division: nil
    )
    |> with_record(%{
      games: 10,
      wins: 2
    })

    league = Repo.preload(league, conferences: [:divisions, :league, teams: :record])

    render_surface do
      ~F"""
        <LeagueStandings id={"#{league.slug}-standings"} league={league} />
      """
    end
  end

  test_snapshot "renders all of its division standings if the league has divisions but no conferences",
                %{league: league} do
    american_league_east = insert(:division, name: "AL East", league: league, conference: nil)

    insert(:team,
      name: "Boston",
      nickname: "Red Sox",
      league: league,
      conference: nil,
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
      conference: nil,
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
      conference: nil,
      division: american_league_east
    )
    |> with_record(%{
      games: 10,
      wins: 8
    })

    national_league_east =
      insert(:division, name: "National League East", league: league, conference: nil)

    insert(:team,
      name: "Atlanta",
      nickname: "Braves",
      league: league,
      conference: nil,
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
      conference: nil,
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
      conference: nil,
      division: national_league_east
    )
    |> with_record(%{
      games: 10,
      wins: 3
    })

    league =
      Repo.preload(league, [:conferences, divisions: [:league, :conference, teams: [:record]]])

    render_surface do
      ~F"""
        <LeagueStandings id={"#{league.slug}-standings"} league={league} />
      """
    end
  end

  test_snapshot "renders its team standings if the league has no divisions or conferences", %{
    league: league
  } do
    insert(:team,
      name: "Boston",
      nickname: "Red Sox",
      league: league,
      conference: nil,
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
      conference: nil,
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
      conference: nil,
      division: nil
    )
    |> with_record(%{
      games: 10,
      wins: 8
    })

    league = Repo.preload(league, [:conferences, :divisions, teams: [:record]])

    render_surface do
      ~F"""
        <LeagueStandings id={"#{league.slug}-standings"} league={league} />
      """
    end
  end
end
