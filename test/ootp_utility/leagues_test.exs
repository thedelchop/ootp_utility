defmodule OOTPUtility.LeaguesTest do
  use OOTPUtility.DataCase, async: true

  alias OOTPUtility.Leagues
  import OOTPUtility.Factory

  describe "get_league!/1" do
    setup do
      {:ok, league: insert(:league)}
    end

    test "returns the %League{} which is associated with the specified ID", %{league: league} do
      assert Leagues.get_league!(league.id).id == league.id
    end

    test "returns an Ecto.NoResultsError if the league with given id can not be found" do
      assert_raise Ecto.NoResultsError, fn -> Leagues.get_league!("no-id") end
    end
  end

  describe "get_league_by_slug!/1" do
    setup do
      {:ok, league: insert(:league)}
    end

    test "returns the league with given slug", %{league: league} do
      assert Leagues.get_league_by_slug!(league.slug).id == league.id
    end

    test "returns an Ecto.NoResultsError if the league with given slug can not be found" do
      assert_raise Ecto.NoResultsError, fn -> Leagues.get_league_by_slug!("no-slug") end
    end
  end

  describe "get_league_level/1" do
    setup do
      major_league_level = %Leagues.Level{
        id: :major,
        abbr: "ML",
        name: "Major League"
      }

      {:ok,
       league: insert(:league, level: major_league_level.id), league_level: major_league_level}
    end

    test "returns a %League.Leve{}, when given a %League{}", %{
      league: league,
      league_level: major_league_level
    } do
      assert Leagues.get_league_level(league) == major_league_level
    end

    test "returns a %League.Leve{}, when given a String.t()", %{league_level: major_league_level} do
      assert Leagues.get_league_level("major") == major_league_level
    end

    test "returns a %League.Leve{}, when given a atom", %{league_level: major_league_level} do
      assert Leagues.get_league_level(:major) == major_league_level
    end
  end

  describe "get_conference!/1" do
    setup do
      {:ok, conference: insert(:conference)}
    end

    test "returns the %Conference{} which is associated with the specified ID", %{
      conference: conference
    } do
      assert Leagues.get_conference!(conference.id).id == conference.id
    end

    test "returns an Ecto.NoResultsError if the league with given id can not be found" do
      assert_raise Ecto.NoResultsError, fn -> Leagues.get_conference!("no-id") end
    end
  end

  describe "get_conference_by_slug!/1" do
    setup do
      {:ok, conference: insert(:conference)}
    end

    test "returns the conference with given slug", %{conference: conference} do
      assert Leagues.get_conference_by_slug!(conference.slug).id == conference.id
    end

    test "returns an Ecto.NoResultsError if the conference with given slug can not be found" do
      assert_raise Ecto.NoResultsError, fn -> Leagues.get_conference_by_slug!("no-slug") end
    end
  end

  describe "get_division_by_slug!/1" do
    setup do
      {:ok, division: insert(:division)}
    end

    test "returns the division with given slug", %{division: division} do
      assert Leagues.get_division_by_slug!(division.slug).id == division.id
    end

    test "returns an Ecto.NoResultsError if the division with given slug can not be found" do
      assert_raise Ecto.NoResultsError, fn -> Leagues.get_division_by_slug!("no-slug") end
    end
  end
end
