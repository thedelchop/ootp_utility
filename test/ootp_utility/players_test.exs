defmodule OOTPUtility.PlayersTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Players

  describe "players" do
    import OOTPUtility.{LeaguesFixtures, PlayersFixtures, TeamsFixtures}

    setup do
      division =
        league_fixture()
        |> conference_fixture()
        |> division_fixture()

      team = team_fixture(%{id: "1"}, division)

      {:ok, team: team, division: division}
    end

    test "for_team/1 returns all players associated with the specified team", %{team: team, division: division} do
      other_team = team_fixture(%{id: "2"}, division)

      team_player = player_fixture(team)
      _other_team_player = player_fixture(%{id: "2"}, other_team)

      assert Players.for_team(team) == [team_player]
    end

    test "get_player!/1 returns the player with given id", %{team: team} do
      player = player_fixture(team)
      assert Players.get_player!(player.id) == player
    end
  end
end
