defmodule OOTPUtility.DivisionFactory do
  alias OOTPUtility.{Leagues, Repo}
  import OOTPUtility.Factories.Utilities, only: [generate_slug_from_name: 1]

  defmacro __using__(_opts) do
    quote do
      def division_factory(attrs) do
        league = Map.get_lazy(attrs, :league, fn -> insert(:league) end)

        conference =
          Map.get_lazy(attrs, :conference, fn -> build(:conference, league: league) end)

        division = %Leagues.Division{
          id: sequence(:id, &"#{&1}"),
          name: sequence("Test Division"),
          slug: fn d -> generate_slug_from_name(d) end,
          league: league,
          conference: conference
        }

        division
        |> merge_attributes(Map.delete(attrs, [:league, :conference]))
        |> evaluate_lazy_attributes()
      end

      def with_teams(%Leagues.Division{league: league, conference: nil} = division) do
        build_list(4, :team, division: division, league: league)

        Repo.preload(division, :teams)
      end

      def with_teams(%Leagues.Division{league: league, conference: conference} = division) do
        build_list(4, :team, league: league, conference: conference, division: division)

        Repo.preload(division, :teams)
      end
    end
  end
end
