defmodule OOTPUtility.LeaguesTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Leagues

  describe "leagues" do
    alias OOTPUtility.Leagues.League

    import OOTPUtility.LeaguesFixtures

    @invalid_attrs %{abbr: nil, current_date: nil, league_level: nil, logo_filename: nil, name: nil, season_year: nil, start_date: nil}

    test "list_leagues/0 returns all leagues" do
      league = league_fixture()
      assert Leagues.list_leagues() == [league]
    end

    test "get_league!/1 returns the league with given id" do
      league = league_fixture()
      assert Leagues.get_league!(league.id) == league
    end

    test "create_league/1 with valid data creates a league" do
      valid_attrs = %{abbr: "some abbr", current_date: ~D[2021-09-05], league_level: "some league_level", logo_filename: "some logo_filename", name: "some name", season_year: 42, start_date: ~D[2021-09-05]}

      assert {:ok, %League{} = league} = Leagues.create_league(valid_attrs)
      assert league.abbr == "some abbr"
      assert league.current_date == ~D[2021-09-05]
      assert league.league_level == "some league_level"
      assert league.logo_filename == "some logo_filename"
      assert league.name == "some name"
      assert league.season_year == 42
      assert league.start_date == ~D[2021-09-05]
    end

    test "create_league/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Leagues.create_league(@invalid_attrs)
    end

    test "update_league/2 with valid data updates the league" do
      league = league_fixture()
      update_attrs = %{abbr: "some updated abbr", current_date: ~D[2021-09-06], league_level: "some updated league_level", logo_filename: "some updated logo_filename", name: "some updated name", season_year: 43, start_date: ~D[2021-09-06]}

      assert {:ok, %League{} = league} = Leagues.update_league(league, update_attrs)
      assert league.abbr == "some updated abbr"
      assert league.current_date == ~D[2021-09-06]
      assert league.league_level == "some updated league_level"
      assert league.logo_filename == "some updated logo_filename"
      assert league.name == "some updated name"
      assert league.season_year == 43
      assert league.start_date == ~D[2021-09-06]
    end

    test "update_league/2 with invalid data returns error changeset" do
      league = league_fixture()
      assert {:error, %Ecto.Changeset{}} = Leagues.update_league(league, @invalid_attrs)
      assert league == Leagues.get_league!(league.id)
    end

    test "delete_league/1 deletes the league" do
      league = league_fixture()
      assert {:ok, %League{}} = Leagues.delete_league(league)
      assert_raise Ecto.NoResultsError, fn -> Leagues.get_league!(league.id) end
    end

    test "change_league/1 returns a league changeset" do
      league = league_fixture()
      assert %Ecto.Changeset{} = Leagues.change_league(league)
    end
  end
end
