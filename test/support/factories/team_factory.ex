defmodule OOTPUtility.TeamFactory do
  alias OOTPUtility.{Leagues, Repo, Teams}

  import OOTPUtility.Factories.Utilities, only: [generate_slug_from_name: 1]

  defmacro __using__(_opts) do
    quote do
      @doc """
      Create a team using ExMachina, which will attempt to be smart about inserting the
      team in the correct parent based on the attributes passed in.

      iex> insert(:team, league: league)
      %Teams.Team{}

      """
      def team_factory(attrs \\ %{}) do
        attrs =
          if Map.has_key?(attrs, :level) and not Map.has_key?(attrs, :league) do
            level = Map.fetch!(attrs, :level)

            Map.put(attrs, :league, insert(:league, level: level))
          else
            attrs
          end

        league = Map.get_lazy(attrs, :league, fn -> insert(:league) end)

        conference =
          Map.get_lazy(attrs, :conference, fn -> insert(:conference, league: league) end)

        division =
          Map.get_lazy(attrs, :division, fn ->
            build(:division, conference: conference, league: league)
          end)

        %Teams.Team{
          id: sequence(:id, &"#{&1}"),
          name: sequence("Test Team"),
          slug: fn t -> generate_slug_from_name(t) end,
          abbr: "TT",
          level: fn t -> t.league.level end,
          logo_filename: "my_team.png",
          organization: nil,
          league: league,
          conference: conference,
          division: division
        }
        |> merge_attributes(Map.drop(attrs, [:level, :league, :conference, :division]))
        |> evaluate_lazy_attributes()
      end

      @doc """
      Adds the specified number of teams to the specified parent.  It attempts to be smart
      about where the teams are added, adding the teams to the most granular child of the parent
      passed in to the function.

      For example, if `with_teams/2` is called with a League that has conferences, but those conferences
      have no divisions, then the teams will be added to the conferences.  If a league with no conferences
      or divisions is passed in then the teams are added directly to the league

      ## Parameters

      parent - A League, Conference or Division to which the teams will be added
      number_of_teams - The number of teams to add to the parent

      """
      @spec with_teams(Leagues.t(), integer()) :: Leagues.t()
      def with_teams(league_conference_or_division, number_of_teams \\ 4)

      def with_teams(
            %Leagues.League{divisions: %Ecto.Association.NotLoaded{}} = league,
            number_of_teams
          ) do
        league
        |> preload_teams_associations()
        |> with_teams(number_of_teams)
      end

      def with_teams(
            %Leagues.League{divisions: [], conferences: %Ecto.Association.NotLoaded{}} = league,
            number_of_teams
          ) do
        league
        |> preload_teams_associations()
        |> with_teams(number_of_teams)
      end

      def with_teams(%Leagues.League{divisions: [], conferences: []} = league, number_of_teams) do
        %{
          league
          | teams:
              insert_list(number_of_teams, :team, league: league, division: nil, conference: nil)
        }
      end

      def with_teams(
            %Leagues.League{divisions: [], conferences: conferences} = league,
            number_of_teams
          ) do
        conferences = Enum.map(conferences, &with_teams(&1, number_of_teams))

        %{league | conferences: conferences, teams: Enum.flat_map(conferences, & &1.teams)}
      end

      def with_teams(
            %Leagues.League{divisions: divisions} = league,
            number_of_teams
          ) do
        divisions = Enum.map(divisions, &with_teams(&1, number_of_teams))

        %{league | divisions: divisions, teams: Enum.flat_map(divisions, & &1.teams)}
      end

      def with_teams(
            %Leagues.Conference{divisions: %Ecto.Association.NotLoaded{}} = conference,
            number_of_teams
          ) do
        conference
        |> preload_teams_associations()
        |> with_teams(number_of_teams)
      end

      def with_teams(
            %Leagues.Conference{league: %Ecto.Association.NotLoaded{}} = conference,
            number_of_teams
          ) do
        conference
        |> preload_teams_associations()
        |> with_teams(number_of_teams)
      end

      def with_teams(
            %Leagues.Conference{divisions: [], league: league} = conference,
            number_of_teams
          ) do
        %{
          conference
          | teams:
              insert_list(number_of_teams, :team,
                league: league,
                conference: conference,
                division: nil
              )
        }
      end

      def with_teams(
            %Leagues.Conference{divisions: divisions, league: league} = conference,
            number_of_teams
          ) do
        divisions = Enum.map(divisions, &with_teams(&1, number_of_teams))
        %{conference | divisions: divisions, teams: Enum.flat_map(divisions, & &1.teams)}
      end

      def with_teams(
            %Leagues.Division{league: %Ecto.Association.NotLoaded{}} = division,
            number_of_teams
          ) do
        division
        |> preload_teams_associations()
        |> with_teams(number_of_teams)
      end

      def with_teams(
            %Leagues.Division{conference: %Ecto.Association.NotLoaded{}} = division,
            number_of_teams
          ) do
        division
        |> preload_teams_associations()
        |> with_teams(number_of_teams)
      end

      def with_teams(
            %Leagues.Division{league: league, conference: nil} = division,
            number_of_teams
          ) do
        %{
          division
          | teams:
              insert_list(number_of_teams, :team,
                division: division,
                conference: nil,
                league: league
              )
        }
      end

      def with_teams(
            %Leagues.Division{league: league, conference: conference} = division,
            number_of_teams
          ) do
        %{
          division
          | teams:
              insert_list(number_of_teams, :team,
                league: league,
                conference: conference,
                division: division
              )
        }
      end

      defp preload_teams_associations(%Leagues.League{} = league) do
        Repo.preload(league, [:divisions, :conferences])
      end

      defp preload_teams_associations(%Leagues.Conference{} = conference) do
        Repo.preload(conference, [:divisions, :league])
      end

      defp preload_teams_associations(%Leagues.Division{} = division) do
        Repo.preload(division, [:conference, :league])
      end

      @doc """
      Updates the team to make that team itself the organization for the team.

      """

      @spec as_organization(Teams.Team.t()) :: Teams.Team.t()
      def as_organization(%Teams.Team{organization: %Ecto.Association.NotLoaded{}} = team) do
        Repo.preload(team, :organization)
      end

      def as_organization(%Teams.Team{organization: nil} = team) do
        %{team | organization: team}
      end

      @doc """
        Insert a set of affiliates for the specified team, by default a full set of affiliates
        are created, but that can be changed with the `affilates` option

      """
      @spec with_affiliates(Teams.Team.t(), [Teams.Team.t()]) :: Teams.Team.t()
      def with_affiliates(team, opts \\ [])

      def with_affiliates(%Teams.Team{} = team, []) do
        affiliates =
          [:major, :triple_a, :double_a, :single_a, :low_a, :rookie]
          |> Enum.map(&insert(:team, level: &1))

        with_affiliates(team, affiliates)
      end

      def with_affiliates(%Teams.Team{} = team, affiliates) do
        affiliations =
          affiliates
          |> Enum.map(&insert(:affiliation, team: team, affiliate: &1))

        %{team | affiliations: affiliations}
      end

      def affiliation_factory(attrs) do
        level = Map.get(attrs, :level, :triple_a)
        team = Map.get_lazy(attrs, :team, fn -> build(:team) end)
        affiliate = Map.get_lazy(attrs, :affiliate, fn -> build(:team, level: level) end)

        %Teams.Affiliation{
          id: sequence(:id, &"#{&1}"),
          team: team,
          affiliate: affiliate
        }
        |> merge_attributes(Map.drop(attrs, [:level, :team, :affiliate]))
        |> evaluate_lazy_attributes()
      end

      def organization_factory do
        build(:team,
          organization: fn t -> t end,
          affiliations: fn t ->
            [:major, :triple_a, :double_a, :single_a, :low_a, :rookie]
            |> Enum.map(&build(:affiliation, team: t, level: &1))
          end
        )
      end
    end
  end
end
