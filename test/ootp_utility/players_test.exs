defmodule OOTPUtility.PlayersTest do
  use OOTPUtility.DataCase, async: true

  alias OOTPUtility.Players
  import OOTPUtility.Factory

  describe "for_team/2" do
    test "for_team/1 returns all players associated with the specified team" do
      team = insert(:team, id: "1")

      other_team = insert(:team, id: "2")

      team_player = insert(:player, team: team)
      _other_team_player = insert(:player, id: "2", team: other_team)

      assert ids_for(Players.for_team(team)) == ids_for([team_player])
    end

    test "it returns all pitchers for the specified team, when the `position` 'P' is specified" do
      team = insert(:team, id: "1")

      starting_pitchers = insert_pair(:player, team: team, position: "SP")
      relievers = insert_pair(:player, team: team, position: "MR")
      closer = insert(:player, team: team, position: "CL")
      catchers = insert_pair(:player, team: team, position: "C")

      pitchers = Players.for_team(team, position: "P")

      assert ids_for(pitchers) == ids_for(starting_pitchers ++ relievers ++ [closer])

      refute Enum.any?(ids_for(catchers), &Enum.member?(ids_for(pitchers), &1))
    end

    test "it returns all infielders for the specified team, when the `position` 'IF' is specified" do
      team = insert(:team, id: "1")

      infielders = Enum.map(["1B", "2B", "3B", "SS"], &insert(:player, team: team, position: &1))
      catchers = insert_pair(:player, team: team, position: "C")

      players = Players.for_team(team, position: "IF")

      assert ids_for(players) == ids_for(infielders)

      refute Enum.any?(ids_for(catchers), &Enum.member?(ids_for(players), &1))
    end

    test "it returns all outfielders for the specified team, when the `position` 'OF' is specified" do
      team = insert(:team, id: "1")

      outfielders = Enum.map(["LF", "CF", "RF"], &insert(:player, team: team, position: &1))
      catchers = insert_pair(:player, team: team, position: "C")

      players = Players.for_team(team, position: "OF")

      assert ids_for(players) == ids_for(outfielders)

      refute Enum.any?(ids_for(catchers), &Enum.member?(ids_for(players), &1))
    end

    test "it returns all players for the specified position if a single position is specified" do
      team = insert(:team, id: "1")

      third_basemen = insert_pair(:player, team: team, position: "3B")
      catchers = insert_pair(:player, team: team, position: "C")

      players = Players.for_team(team, position: "3B")

      assert ids_for(players) == ids_for(third_basemen)

      refute Enum.any?(ids_for(catchers), &Enum.member?(ids_for(players), &1))
    end

    test "it returns only players from the specified roster if the `roster` option is specified" do
      team = insert(:team)

      active_roster = build(:team_roster, team: team)

      expanded_roster = build(:team_roster, team: team, type: :expanded)

      players = Players.for_team(team, roster: :active)

      assert ids_for(players) == ids_for(active_roster.players)
      refute ids_for(players) == ids_for(expanded_roster.players)
    end
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
