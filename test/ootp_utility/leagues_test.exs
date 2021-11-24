defmodule OOTPUtility.LeaguesTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Leagues
  import OOTPUtility.Factory

  describe "leagues" do
    setup do
      {:ok, league: insert(:league)}
    end

    test "list_leagues/0 returns all leagues", %{league: league} do
      assert ids_for(Leagues.list_leagues()) == ids_for([league])
    end

    test "get_league!/1 returns the league with given id", %{league: league} do
      assert Leagues.get_league!(league.slug).id == league.id
    end
  end

  describe "conferences" do
    setup do
      {:ok, conference: insert(:conference)}
    end

    test "list_conferences/0 returns all conferences", %{conference: conference} do
      assert ids_for(Leagues.list_conferences()) == ids_for([conference])
    end

    test "get_conference!/1 returns the conference with given id", %{conference: conference} do
      assert Leagues.get_conference!(conference.slug).id == conference.id
    end
  end

  describe "divisions" do
    setup do
      {:ok, division: insert(:division)}
    end

    test "list_divisions/0 returns all divisions", %{division: division} do
      assert ids_for(Leagues.list_divisions()) == ids_for([division])
    end

    test "get_division!/1 returns the division with given id", %{division: division} do
      assert Leagues.get_division!(division.slug).id == division.id
    end
  end
end
