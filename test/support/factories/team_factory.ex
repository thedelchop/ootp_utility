defmodule OOTPUtility.TeamFactory do
  alias OOTPUtility.{Leagues, Repo, Teams}

  import OOTPUtility.Factories.Utilities, only: [generate_slug_from_name: 1]

  defmacro __using__(_opts) do
    quote do
      def team_factory(attrs) do
        level = Map.get(attrs, :level, :major)
        league = Map.get_lazy(attrs, :league, fn -> insert(:league, level: level) end)

        conference =
          Map.get_lazy(attrs, :conference, fn -> insert(:conference, league: league) end)

        division =
          Map.get_lazy(attrs, :division, fn ->
            build(:division, conference: conference, league: league)
          end)

        team = %Teams.Team{
          id: sequence(:id, &"#{&1}"),
          name: sequence("Test Team"),
          slug: fn t -> generate_slug_from_name(t) end,
          abbr: "TT",
          level: :major,
          logo_filename: "my_team.png",
          organization: nil,
          league: league,
          conference: conference,
          division: division
        }

        team
        |> merge_attributes(attrs)
        |> evaluate_lazy_attributes()
      end

      def with_teams(league_conference_or_division, number_of_teams \\ 4)

      def with_teams(
            %Leagues.League{conferences: %Ecto.Association.NotLoaded{}} = league,
            number_of_teams
          ) do
        league
        |> preload_teams_associations()
        |> with_teams(number_of_teams)
      end

      def with_teams(
            %Leagues.League{divisions: %Ecto.Association.NotLoaded{}} = league,
            number_of_teams
          ) do
        league
        |> preload_teams_associations()
        |> with_teams(number_of_teams)
      end

      def with_teams(%Leagues.League{conferences: [], divisions: []} = league, number_of_teams) do
        insert_list(number_of_teams, :team, league: league)

        Repo.preload(league, :teams)
      end

      def with_teams(
            %Leagues.League{conferences: [], divisions: divisions} = league,
            number_of_teams
          ) do
        Enum.each(divisions, &with_teams(&1, number_of_teams))

        Repo.preload(league, divisions: [:teams])
      end

      def with_teams(%Leagues.League{conferences: conferences} = league, number_of_teams) do
        Enum.each(conferences, &with_teams(&1, number_of_teams))

        Repo.preload(league, conferences: [:teams])
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
        insert_list(number_of_teams, :team, league: league, conference: conference, division: nil)

        Repo.preload(conference, :teams)
      end

      def with_teams(
            %Leagues.Conference{divisions: divisions, league: league} = conference,
            number_of_teams
          ) do
        Enum.each(
          divisions,
          &insert_list(number_of_teams, :team, division: &1, conference: conference, league: league)
        )

        Repo.preload(conference, divisions: [:teams])
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
        insert_list(number_of_teams, :team, division: division, league: league)

        Repo.preload(division, :teams)
      end

      def with_teams(
            %Leagues.Division{league: league, conference: conference} = division,
            number_of_teams
          ) do
        insert_list(number_of_teams, :team,
          league: league,
          conference: conference,
          division: division
        )

        Repo.preload(division, :teams)
      end

      defp preload_teams_associations(%Leagues.League{} = league) do
        Repo.preload(league, :divisions, conferences: [:divisions])
      end

      defp preload_teams_associations(%Leagues.Conference{} = conference) do
        Repo.preload(conference, [:divisions, :league])
      end

      defp preload_teams_associations(%Leagues.Division{} = division) do
        Repo.preload(division, [:conference, :league])
      end

      def as_organization(%Teams.Team{organization: %Ecto.Association.NotLoaded{}} = team) do
        Repo.preload(team, :organization)
      end

      def as_organization(%Teams.Team{organization: nil} = team) do
        %{team | organization: team}
      end

      def with_affiliates(%Teams.Team{} = team, opts \\ []) do
        levels =
          Keyword.get(opts, :levels, [:major, :triple_a, :double_a, :single_a, :low_a, :rookie])

        Enum.map(levels, &insert(:affiliation, team: team, level: &1))

        team
      end

      def affiliation_factory(attrs) do
        level = Map.get(attrs, :level, :triple_a)
        team = Map.get_lazy(attrs, :team, fn -> build(:team) end)
        affiliate = Map.get_lazy(attrs, :affiliate, fn -> build(:team, level: level) end)

        affiliation = %Teams.Affiliation{
          id: sequence(:id, &"#{&1}"),
          team: team,
          affiliate: affiliate
        }

        affiliation
        |> merge_attributes(Map.delete(attrs, :level))
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
