defmodule OOTPUtility.StandingsTest do
  use OOTPUtility.DataCase, async: true

  alias OOTPUtility.Standings
  import OOTPUtility.Factory

  describe "for_league/1" do
    test "it returns a Standings.League structure composed of conference standings, when the league contains conferences" do
      league =
        insert(:league)
        |> with_conferences()
        |> with_teams()
        |> with_records()

      league_standings = Standings.for_league(league)

      assert league_standings.id == "#{league.slug}-standings"
      assert league_standings.league == league
      assert Enum.empty?(league_standings.division_standings)

      league_standings.conference_standings
      |> Enum.each(&assert(is_struct(&1, Standings.Conference)))
    end

    test "it returns a Standings.League structure composed of division standings, when the league doesn't contain conferences" do
      league =
        insert(:league)
        |> with_divisions()
        |> with_teams()
        |> with_records()

      league_standings = Standings.for_league(league)

      assert league_standings.id == "#{league.slug}-standings"
      assert league_standings.league == league
      assert Enum.empty?(league_standings.conference_standings)

      league_standings.division_standings
      |> Enum.each(&assert(is_struct(&1, Standings.Division)))
    end
  end

  describe "for_conference/1" do
    test "it returns a Standings.Conference structure composed of division standings, when the conference contains divisions" do
      conference =
        insert(:conference)
        |> with_divisions()
        |> with_teams()
        |> with_records()

      conference_standings = Standings.for_conference(conference)

      assert conference_standings.id == "#{conference.slug}-standings"
      assert conference_standings.conference == conference
      assert Enum.empty?(conference_standings.team_standings)

      conference_standings.division_standings
      |> Enum.each(&assert(is_struct(&1, Standings.Division)))
    end

    test "it returns a Standings.Conference structure composed of team standings, when the conference doesn't contain divisions" do
      conference =
        insert(:conference)
        |> with_teams()
        |> with_records()

      conference_standings = Standings.for_conference(conference)

      assert conference_standings.id == "#{conference.slug}-standings"
      assert conference_standings.conference == conference
      assert Enum.empty?(conference_standings.division_standings)

      conference_standings.team_standings
      |> Enum.each(&assert(is_struct(&1, Standings.Team)))
    end
  end

  describe "for_division/1" do
    test "it returns a Standings.Division structure composed of team standings" do
      division =
        insert(:division)
        |> with_teams()
        |> with_records()

      division_standings = Standings.for_division(division)

      assert division_standings.id == "#{division.slug}-standings"
      assert division_standings.division == division

      division_standings.team_standings
      |> Enum.each(&assert(is_struct(&1, Standings.Team)))
    end
  end

  describe "for_team/1" do
    test "it returns the standings for the specified team" do
      team =
        insert(:team,
          name: "Bad News Bears",
          slug: "bad-news-bears",
          abbr: "BNB",
          logo_filename: "/logos/bad_news_bears.png"
        )
        |> with_record(%{
          games: 6,
          games_behind: 1.0,
          losses: 3,
          magic_number: 150,
          position: 3,
          streak: 2,
          winning_percentage: 0.500,
          wins: 3
        })

      assert Standings.for_team(team) == %Standings.Team{
               id: "bad-news-bears-standings",
               name: "Bad News Bears",
               abbr: "BNB",
               slug: "bad-news-bears",
               logo_filename: "/logos/bad_news_bears.png",
               games: 6,
               wins: 3,
               losses: 3,
               games_behind: 1.0,
               winning_percentage: 0.5,
               position: 3,
               streak: 2,
               magic_number: 150
             }
    end
  end

  describe "for_team/2" do
    setup do
      mlb = insert(:league, name: "Major League Baseball")

      american_league = insert(:conference, name: "American League", league: mlb)
      national_league = insert(:conference, name: "National League", league: mlb)

      al_east = insert(:division, name: "AL East", conference: american_league)
      al_west = insert(:division, name: "AL West", conference: american_league)

      nl_west = insert(:division, name: "NL West", conference: national_league)

      insert(:team,
          name: "New York",
          nickname: "Yankees",
          league: mlb,
          conference: american_league,
          division: al_east
        )
        |> with_record(%{
          games: 162,
          wins: 81,
          games_behind: 1.0,
          position: 2
        })

      insert(:team,
          name: "Los Angeles",
          nickname: "Angels",
          league: mlb,
          conference: american_league,
          division: al_west
        )
        |> with_record(%{
          games: 162,
          wins: 100,
          games_behind: 0.0,
          position: 1
        })

      insert(:team,
          name: "Los Angeles",
          nickname: "Dodgers",
          league: mlb,
          conference: national_league,
          division: nl_west
        )
        |> with_record(%{
          games: 162,
          wins: 98,
          games_behind: 0.0,
          position: 1
        })

      red_sox = insert(:team,
          name: "Boston",
          nickname: "Red Sox",
          abbr: "BOS",
          logo_filename: "/logos/boston_red_sox.png",
          league: mlb,
          conference: american_league,
          division: al_east
        )
        |> with_record(%{
          games: 162,
          games_behind: 0.0,
          losses: 65,
          magic_number: 0,
          position: 1,
          streak: 2,
          winning_percentage: 0.599,
          wins: 97
        })

      {:ok, red_sox: red_sox, mlb: mlb, american_league: american_league}
    end

    test "it returns the standings for the specified team in the specified conference",
      %{red_sox: red_sox, american_league: american_league} do

      assert Standings.for_team(red_sox, american_league) == %Standings.Team{
               id: "boston-red-sox-standings",
               name: "Boston Red Sox",
               abbr: "BOS",
               slug: "boston-red-sox",
               logo_filename: "/logos/boston_red_sox.png",
               games: 162,
               wins: 97,
               losses: 65,
               games_behind: 3.0,
               winning_percentage: 0.599,
               position: 2,
               streak: 2,
               magic_number: 0
             }
    end

    test "it returns the standings for the specified team in the specified league",
      %{red_sox: red_sox, mlb: mlb} do

      assert Standings.for_team(red_sox, mlb) == %Standings.Team{
               id: "boston-red-sox-standings",
               name: "Boston Red Sox",
               abbr: "BOS",
               slug: "boston-red-sox",
               logo_filename: "/logos/boston_red_sox.png",
               games: 162,
               wins: 97,
               losses: 65,
               games_behind: 3.0,
               winning_percentage: 0.599,
               position: 3,
               streak: 2,
               magic_number: 0
             }
    end
  end
end
