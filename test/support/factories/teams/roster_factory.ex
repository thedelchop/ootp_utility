defmodule OOTPUtility.Teams.RosterFactory do
  alias OOTPUtility.{Repo, Teams}

  defmacro __using__(_opts) do
    quote do
      def team_roster_factory do
        %Teams.Roster{
          type: :active,
          team: insert(:team),
          players: fn roster -> create_players_for_roster(roster) end
        }
      end

      def team_roster_membership_factory(attrs) do
        attrs =
          if Map.has_key?(attrs, :player) do
            player = Map.fetch!(attrs, :player)

            Map.put(attrs, :team, player.team)
          else
            attrs
          end

        %Teams.Roster.Membership{
          id: sequence(:id, &"#{&1}"),
          team: build(:team),
          player: fn mem -> build(:player, team: mem.team) end,
          type: :active
        }
        |> merge_attributes(attrs)
        |> evaluate_lazy_attributes()
      end

      @doc """
        Add rosters to the teams that are children of the specified parent.

        This attempts to be smart about the way that we construct the rosters,
        searching through the parent's children to determine at which level the
        parent's teams are stored and adding rosters to them.

        For example:

          League -> Conferences -> Divisions -> Teams =>  Wil add to the teams in the divisions

        Also takes the attributes for the roster being created to give youi the ability specify
        what the roster looks like.

      ## Examples

        iex> insert(:league) |> with_rosters(%{type: expanded})
          %Leagues.League{}

        iex> insert(:conference) |> with_rosters(%{type: expanded})
          %Leagues.Conference{}

      """
      @spec with_rosters(Leagues.t(), map()) :: Leagues.t()
      def with_rosters(league_or_conference_or_division, roster_attrs \\ %{})

      def with_rosters(%{teams: %Ecto.Association.NotLoaded{}} = parent, roster_attrs) do
        parent
        |> Repo.preload(:teams)
        |> with_rosters(roster_attrs)
      end

      def with_rosters(%{teams: teams} = parent, roster_attrs) do
        teams = Enum.map(teams, &with_roster(&1, roster_attrs))

        %{parent | teams: teams}
      end

      @doc """
        Add a roster of players to the specified team, usign the `roster_attributes` map provided.

      ## Examples

        iex> insert(:team) |> with_rosters(%{type: expanded})
          %Teams.Team{}

        iex> %Teams.Team{} |> with_rosters(%{type: expanded})
          %Teams.Team{}
      """
      @spec with_roster(Teams.Team.t(), map()) :: Teams.Team.t()
      def with_roster(%Teams.Team{} = team, roster_attrs \\ %{}) do
        roster_attrs = Map.put(roster_attrs, :team, team)

        build(:team_roster, roster_attrs)

        team
      end

      defp create_players_for_roster(%Teams.Roster{team: team, type: type}) do
        players =
          team
          |> do_create_players_for_roster(type)
          |> List.flatten()

        Enum.each(players, &do_create_roster_membership(&1, team, type))

        players
      end

      defp do_create_players_for_roster(team, type \\ :active)

      defp do_create_players_for_roster(team, :active) do
        [
          insert_list(5, :player, position: :starting_pitcher, team: team),
          insert_list(6, :player, position: :middle_reliever, team: team),
          insert(:player, position: :closer, team: team),
          insert_pair(:player, position: :catcher, team: team),
          insert_pair(:player, position: :first_base, team: team),
          insert_pair(:player, position: :second_base, team: team),
          insert(:player, position: :shortstop, team: team),
          insert(:player, position: :third_base, team: team),
          insert_pair(:player, position: :left_field, team: team),
          insert(:player, position: :center_field, team: team),
          insert(:player, position: :right_field, team: team),
          insert(:player, position: :designated_hitter, team: team)
        ]
      end

      defp do_create_players_for_roster(team, :expanded) do
        [
          do_create_players_for_roster(team, :active),
          insert_pair(:player, position: :catcher, team: team),
          insert(:player, position: :first_base, team: team),
          insert_pair(:player, position: :shortstop, team: team),
          insert(:player, position: :third_base, team: team),
          insert(:player, position: :left_field, team: team),
          insert(:player, position: :center_field, team: team),
          insert(:player, position: :right_field, team: team),
          insert_list(3, :player, position: :starting_pitcher, team: team),
          insert_list(3, :player, position: :middle_reliever, team: team)
        ]
        |> List.flatten()
      end

      defp do_create_players_for_roster(team, :injured) do
        [
          insert_list(2, :player, position: :starting_pitcher, team: team),
          insert(:player, position: :first_base, team: team),
          insert(:player, position: :left_field, team: team)
        ]
        |> List.flatten()
      end

      defp do_create_roster_membership(player, team, type) do
        insert(:team_roster_membership, team: team, player: player, type: type)
      end
    end
  end
end
