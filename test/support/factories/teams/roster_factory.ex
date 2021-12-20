defmodule OOTPUtility.Teams.RosterFactory do
  alias OOTPUtility.Teams.Roster

  defmacro __using__(_opts) do
    quote do
      def team_roster_factory do
        %Roster{
          type: :active,
          team: insert(:team),
          players: fn roster -> create_players_for_roster(roster) end
        }
      end

      def team_roster_membership_factory do
        %Roster.Membership{
          id: sequence(:id, &"#{&1}"),
          team: build(:team),
          player: fn mem -> build(:player, team: mem.team) end,
          type: :active
        }
      end

      defp create_players_for_roster(%Roster{team: team, type: :active}) do
        players =
          team
          |> do_create_players_for_active_roster(:active)
          |> List.flatten()

        Enum.each(players, &do_create_roster_membership(&1, team, :active))

        players
      end

      defp do_create_players_for_active_roster(team, type \\ :active) do
        [
          insert_list(5, :player, position: "SP", team: team),
          insert_list(6, :player, position: "MR", team: team),
          insert(:player, position: "CL", team: team),
          insert_pair(:player, position: "C", team: team),
          insert_pair(:player, position: "1B", team: team),
          insert_pair(:player, position: "2B", team: team),
          insert(:player, position: "SS", team: team),
          insert(:player, position: "3B", team: team),
          insert_pair(:player, position: "LF", team: team),
          insert(:player, position: "CF", team: team),
          insert(:player, position: "RF", team: team),
          insert(:player, position: "DH", team: team)
        ]
      end

      defp create_players_for_roster(%Roster{team: team, type: :expanded} = roster) do
        players =
          [
            do_create_players_for_active_roster(team, :expanded),
            insert_pair(:player, position: "C", team: team),
            insert(:player, position: "1B", team: team),
            insert_pair(:player, position: "SS", team: team),
            insert(:player, position: "3B", team: team),
            insert(:player, position: "LF", team: team),
            insert(:player, position: "CF", team: team),
            insert(:player, position: "RF", team: team),
            insert_list(3, :player, position: "SP", team: team),
            insert_list(3, :player, position: "MR", team: team)
          ]
          |> List.flatten()

        Enum.each(players, &do_create_roster_membership(&1, team, :expanded))

        players
      end

      defp create_players_for_roster(%Roster{team: team, type: :injured}) do
        players =
          [
            insert_list(2, :player, position: "SP", team: team),
            insert(:player, position: "1B", team: team),
            insert(:player, position: "LF", team: team)
          ]
          |> List.flatten()

        Enum.each(players, &do_create_roster_membership(&1, team, :injured))

        players
      end

      defp do_create_roster_membership(player, team, type) do
        insert(:team_roster_membership, team: team, player: player, type: type)
      end
    end
  end
end
