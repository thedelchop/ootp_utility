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

      starting_pitchers = insert_pair(:player, team: team, position: :starting_pitcher)
      relievers = insert_pair(:player, team: team, position: :middle_reliever)
      closer = insert(:player, team: team, position: :closer)
      catchers = insert_pair(:player, team: team, position: :catcher)

      pitchers = Players.for_team(team, position: "P")

      assert ids_for(pitchers) == ids_for(starting_pitchers ++ relievers ++ [closer])

      refute Enum.any?(ids_for(catchers), &Enum.member?(ids_for(pitchers), &1))
    end

    test "it returns all infielders for the specified team, when the `position` 'IF' is specified" do
      team = insert(:team, id: "1")

      infielders =
        Enum.map(
          [:first_base, :second_base, :third_base, :shortstop],
          &insert(:player, team: team, position: &1)
        )

      catchers = insert_pair(:player, team: team, position: :catcher)

      players = Players.for_team(team, position: "IF")

      assert ids_for(players) == ids_for(infielders)

      refute Enum.any?(ids_for(catchers), &Enum.member?(ids_for(players), &1))
    end

    test "it returns all outfielders for the specified team, when the `position` 'OF' is specified" do
      team = insert(:team, id: "1")

      outfielders = Enum.map([:left_field, :center_field, :right_field], &insert(:player, team: team, position: &1))
      catchers = insert_pair(:player, team: team, position: :catcher)

      players = Players.for_team(team, position: "OF")

      assert ids_for(players) == ids_for(outfielders)

      refute Enum.any?(ids_for(catchers), &Enum.member?(ids_for(players), &1))
    end

    test "it returns all players for the specified position if a single position is specified" do
      team = insert(:team, id: "1")

      third_basemen = insert_pair(:player, team: team, position: :third_base)
      catchers = insert_pair(:player, team: team, position: :catcher)

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

  describe "for_organization/1" do
    test "it returns all players in the specified team's organization" do
      organization = insert(:team)
      team = insert(:team, organization: organization)

      organization_members = insert_list(4, :player, team: team, organization: organization)
      non_org_members = insert_pair(:player)

      players = Players.for_organization(team)

      assert ids_for(players) == ids_for(organization_members)

      refute Enum.any?(players, &Enum.member?(non_org_members, &1))
    end
  end

  describe "get_player_by_slug!/1" do
    setup do
      {:ok, player: insert(:player)}
    end

    test "returns the player with the given slug", %{player: player} do
      assert Players.get_player_by_slug!(player.slug).id == player.id
    end

    test "returns an Ecto.NoResultsError if the player with given slug can not be found" do
      assert_raise Ecto.NoResultsError, fn -> Players.get_player_by_slug!("missing-player") end
    end
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
