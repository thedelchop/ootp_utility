defmodule OOTPUtility.LeaguesTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Leagues
  import OOTPUtility.LeaguesFixtures

  setup do
    {:ok, league: league_fixture()}
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
    test "list_conferences/0 returns all conferences", %{league: league} do
      conference = conference_fixture(league)
      assert Leagues.list_conferences() == [conference]
    end

    test "get_conference!/1 returns the conference with given id", %{league: league} do
      conference = conference_fixture(league)
      assert Leagues.get_conference!(conference.id) == conference
    end
  end
end
