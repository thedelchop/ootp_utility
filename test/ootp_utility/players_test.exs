defmodule OOTPUtility.PlayersTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Players
  import OOTPUtility.Factory

  test "for_team/1 returns all players associated with the specified team" do
    division = insert(:division)

    team = insert(:team, id: "1", division: division)

    other_team = insert(:team, id: "2", division: division)

    team_player = insert(:player, team: team)
    _other_team_player = insert(:player, id: "2", team: other_team)

    assert ids_for(Players.for_team(team)) == ids_for([team_player])
  end

  test "get_player!/1 returns the player with given id" do
    player = insert(:player)
    assert Players.get_player!(player.slug).id == player.id
  end

  describe "name/2" do
    setup do
      {:ok, player: insert(:player, first_name: "Test", last_name: "Player")}
    end

    test "it returns the players full name by default if no format option is specified", %{
      player: player
    } do
      assert Players.name(player) == "Test Player"
    end

    test "it returns the players full name if the :full option is specified", %{player: player} do
      assert Players.name(player, :full) == "Test Player"
    end

    test "it returns the players first initial and last name if the :short option is specified",
         %{player: player} do
      assert Players.name(player, :short) == "T. Player"
    end
  end
end
