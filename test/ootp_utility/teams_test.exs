defmodule OOTPUtility.TeamsTest do
  use OOTPUtility.DataCase

  import OOTPUtility.{LeaguesFixtures, TeamsFixtures}

  alias OOTPUtility.Teams

  describe "teams" do
    setup do
      team = league_fixture() |> conference_fixture() |> division_fixture() |> team_fixture()

      {:ok, team: team}
    end

    test "list_teams/0 returns all teams", %{team: team} do
      assert Teams.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id", %{team: team} do
      assert Teams.get_team!(team.id) == team
    end
  end
end
