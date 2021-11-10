defmodule OOTPUtility.PlayersTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Players

  import OOTPUtility.{LeaguesFixtures, PlayersFixtures, TeamsFixtures}

  test "for_team/1 returns all players associated with the specified team" do
    division = division_fixture()

    team = team_fixture(%{id: "1"}, division)

    other_team = team_fixture(%{id: "2"}, division)

    team_player = player_fixture(%{}, team)
    _other_team_player = player_fixture(%{id: "2"}, other_team)

    assert Players.for_team(team) == [team_player]
  end

  test "get_player!/1 returns the player with given id" do
    player = player_fixture(%{})
    assert Players.get_player!(player.slug) == player
  end

  describe "name/2" do
    test "it returns the players full name by default if no format option is specified" do
      player = player_fixture(%{first_name: "Test", last_name: "Player"})

      assert Players.name(player) == "Test Player"
    end

    test "it returns the players full name if the :full option is specified" do
      player = player_fixture(%{first_name: "Test", last_name: "Player"})

      assert Players.name(player, :full) == "Test Player"
    end

    test "it returns the players first initial and last name if the :short option is specified" do
      player = player_fixture(%{first_name: "Test", last_name: "Player"})

      assert Players.name(player, :short) == "T. Player"
    end
  end
end
