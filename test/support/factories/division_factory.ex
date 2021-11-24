defmodule OOTPUtility.DivisionFactory do
  alias OOTPUtility.Leagues.Division
  import OOTPUtility.Factories.Utilities, only: [generate_slug_from_name: 1]

  defmacro __using__(_opts) do
    quote do
      def division_factory do
        %Division{
          id: sequence(:id, &"#{&1}"),
          name: sequence("Test Division"),
          slug: &generate_slug_from_name/1,
          league: fn -> build(:league) end,
          conference: fn division -> build(:conference, league: division.league) end
        }
      end

      def with_teams(%Division{league: league, conference: nil} = division) do
        build_list(4, :team, division: division, league: league)

        division
      end

      def with_teams(%Division{league: league, conference: conference} = division) do
        build_list(4, :team, league: league, conference: conference, division: division)

        division
      end
    end
  end
end
