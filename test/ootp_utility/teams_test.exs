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
end
