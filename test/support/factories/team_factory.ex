defmodule OOTPUtility.TeamFactory do
  alias OOTPUtility.Repo
  alias OOTPUtility.Teams.{Affiliation, Team}

  import OOTPUtility.Factories.Utilities, only: [generate_slug_from_name: 1]

  defmacro __using__(_opts) do
    quote do
      def team_factory(attrs) do
        level = Map.get(attrs, :level, :major)
        league = Map.get_lazy(attrs, :league, fn -> insert(:league, league_level: level) end)

        conference =
          Map.get_lazy(attrs, :conference, fn -> insert(:conference, league: league) end)

        division =
          Map.get_lazy(attrs, :division, fn ->
            build(:division, conference: conference, league: league)
          end)

        team = %Team{
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

      def as_organization(%Team{organization: %Ecto.Association.NotLoaded{}} = team) do
        Repo.preload(team, :organization)
      end

      def as_organization(%Team{organization: nil} = team) do
        %{team | organization: team}
      end

      def with_affiliates(%Team{} = team, opts \\ []) do
        levels =
          Keyword.get(opts, :levels, [:major, :triple_a, :double_a, :single_a, :low_a, :rookie])

        Enum.map(levels, &insert(:affiliation, team: team, level: &1))

        team
      end

      def affiliation_factory(attrs) do
        level = Map.get(attrs, :level, :triple_a)
        team = Map.get_lazy(attrs, :team, fn -> build(:team) end)
        affiliate = Map.get_lazy(attrs, :affiliate, fn -> build(:team, level: level) end)

        affiliation = %Affiliation{
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
