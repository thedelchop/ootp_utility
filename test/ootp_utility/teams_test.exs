defmodule OOTPUtility.TeamsTest do
  use OOTPUtility.DataCase

  import OOTPUtility.Factory

  alias OOTPUtility.Teams

  describe "teams" do
    setup do: {:ok, team: insert(:team)}

    test "list_teams/0 returns all teams", %{team: team} do
      assert ids_for(Teams.list_teams()) == ids_for([team])
    end

    test "get_team!/1 returns the team with given id", %{team: team} do
      assert Teams.get_team!(team.id).id == team.id
    end
  end

  describe "get_roster/2" do
    setup do
      team = insert(:team)

      {
        :ok,
        team: team, active_roster: build(:team_roster, team: team)
      }
    end

    test "it returns the active roster for the team by default", %{
      team: team,
      active_roster: active_roster
    } do
      queried_roster = Teams.get_roster(team)

      assert ids_for(queried_roster.players) == ids_for(active_roster.players)
    end

    test "it returns the expanded roster for the team when the `:expanded` type is provided", %{
      team: team,
      active_roster: active_roster
    } do
      expanded_roster = build(:team_roster, team: team, type: :expanded)

      queried_roster = Teams.get_roster(team, :expanded)

      assert ids_for(queried_roster.players) == ids_for(expanded_roster.players)
      refute ids_for(queried_roster.players) == ids_for(active_roster.players)
    end

    test "it returns the injured roster for the team when the `:injured` type is provided", %{
      team: team,
      active_roster: active_roster
    } do
      injured_roster = build(:team_roster, team: team, type: :injured)

      queried_roster = Teams.get_roster(team, :injured)

      assert ids_for(queried_roster.players) == ids_for(injured_roster.players)
      refute ids_for(queried_roster.players) == ids_for(active_roster.players)
    end
  end

  describe "get_full_name/1" do
    test "returns the name and the nickname of the team, seperated by a space when the team has a nickname" do
      team = insert(:team, name: "Test Town", nickname: "Exceptions")

      assert Teams.get_full_name(team) == "Test Town Exceptions"
    end

    test "returns the name of the team, if the team does not have a nickname" do
      team = insert(:team, name: "Test Town", nickname: nil)

      assert Teams.get_full_name(team) == "Test Town"
    end
  end
end
