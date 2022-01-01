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

      def with_divisions(conference_or_league, number_of_divisions \\ 2)
      def with_divisions(%Leagues.League{conferences: %Ecto.Association.NotLoaded{}} = league, number_of_divisions) do
        league
        |> Repo.preload(:conferences)
        |> with_divisions(number_of_divisions)
      end

      def with_divisions(%Leagues.League{conferences: []} = league, number_of_divisions) do
        insert_list(number_of_divisions, :division, league: league, conference: nil)

        Repo.preload(league, [divisions: [:league, :conference]])
      end

      def with_divisions(%Leagues.League{conferences: conferences} = league, number_of_divisions) do
        Enum.each(conferences, &insert_list(number_of_divisions, :division, conference: &1, league: league))

        Repo.preload(league, [conferences: [divisions: [:league, :conference]]])
      end

      def with_divisions(%Leagues.Conference{league: %Ecto.Association.NotLoaded{}} = conference, number_of_divisions) do
        conference
        |> Repo.preload(:league)
        |> with_divisions(number_of_divisions)
      end

      def with_divisions(%Leagues.Conference{league: league} = conference, number_of_divisions) do
        insert_list(number_of_divisions, :division, league: league, conference: conference)

        Repo.preload(conference, divisions: [:league, :conference])
      end
    end
  end
end
