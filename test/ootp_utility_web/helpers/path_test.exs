defmodule OOTPUtilityWeb.Helpers.PathTest do
  use OOTPUtilityWeb.ConnCase, async: true

  alias OOTPUtilityWeb.Helpers.Path
  import OOTPUtility.Factory

  describe "path_to_team/2" do
    test "returns the path to the team, using the :slug as the identifier", %{conn: conn} do
      team = insert(:team, slug: "bad-news-bears")

      assert Path.path_to_team(team, conn) == "/teams/bad-news-bears"
    end

    test "also accepts a Team.Standings struct", %{conn: conn} do
      standings = build(:team_standings, slug: "bad-news-bears")

      assert Path.path_to_team(standings, conn) == "/teams/bad-news-bears"
    end
  end

  describe "path_to_league" do
    test "it returns the path to the league, using its slug", %{conn: conn} do
      league = build(:league, slug: "my-league")

      assert Path.path_to_league(league, conn) == "/leagues/my-league"
    end
  end

  describe "path_to_conference" do
    test "it returns the path to the conference, nested in its parent league, both identified by their slugs", %{conn: conn} do
      league = build(:league, slug: "my-league")
      conference = build(:conference, league: league, slug: "my-conference")

      assert Path.path_to_conference(conference, conn) == "/leagues/my-league/conferences/my-conference"
    end
  end

  describe "path_to_division" do
    test "it returns the path to the division, nested in its parent league, both identified by their slugs, when the division has no conference", %{conn: conn} do
      league = build(:league, slug: "my-league")
      division = build(:division, slug: "my-division", league: league, conference: nil)

      assert Path.path_to_division(division, conn) == "/leagues/my-league/divisions/my-division"
    end

    test "it returns the path to the division, nested in its parent league and conference, all identified by their slugs, when the division has a conference", %{conn: conn} do
      league = build(:league, slug: "my-league")
      conference = build(:conference, league: league, slug: "my-conference")
      division = build(:division, slug: "my-division", league: league, conference: conference)

      assert Path.path_to_division(division, conn) == "/leagues/my-league/conferences/my-conference/divisions/my-division"
    end
  end
end
