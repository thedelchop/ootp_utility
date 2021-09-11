defmodule OOTPUtility.LeaguesTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Leagues
  import OOTPUtility.LeaguesFixtures

  setup do
    league = league_fixture()

    {:ok, league: league, conference: conference_fixture(league)}
  end

  describe "leagues" do
    test "list_leagues/0 returns all leagues", %{league: league} do
      assert Leagues.list_leagues() == [league]
    end

    test "get_league!/1 returns the league with given id", %{league: league} do
      assert Leagues.get_league!(league.id) == league
    end
  end

  describe "conferences" do
    test "list_conferences/0 returns all conferences", %{conference: conference} do
      assert Leagues.list_conferences() == [conference]
    end

    test "get_conference!/1 returns the conference with given id", %{conference: conference} do
      assert Leagues.get_conference!(conference.id) == conference
    end
  end

  describe "divisions" do
    test "list_divisions/0 returns all divisions", %{conference: conference} do
      division = division_fixture(conference)
      assert Leagues.list_divisions() == [division]
    end

    test "get_division!/1 returns the division with given id", %{conference: conference} do
      division = division_fixture(conference)
      assert Leagues.get_division!(division.id) == division
    end
  end
end
