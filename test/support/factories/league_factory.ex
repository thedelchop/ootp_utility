defmodule OOTPUtility.LeagueFactory do
  alias OOTPUtility.Leagues.League
  import OOTPUtility.Factories.Utilities, only: [generate_slug_from_name: 1]

  defmacro __using__(_opts) do
    quote do
      def league_factory do
        %League{
          id: sequence(:id, &"#{&1}"),
          name: sequence(:name, &"Test League #{&1}"),
          slug: &generate_slug_from_name/1,
          abbr: "TL",
          current_date: ~D[2021-09-05],
          level: :major,
          logo_filename: "test_league.png",
          season_year: 2021,
          start_date: ~D[2021-09-05]
        }
      end

      def with_divisions(%League{} = league) do
        insert_pair(:division, league: league)

        league
      end

      def with_conferences(%League{} = league) do
        insert_pair(:conference, league: league)

        league
      end

      def with_teams(%League{conferences: [], divisions: []} = league) do
        build_list(4, :team, league: league)

        league
      end

      def with_teams(%League{conferences: [], divisions: divisions} = league) do
        Enum.each(divisions, &build_list(4, :team, division: &1, league: league))

        league
      end

      def with_teams(%League{conferences: conferences, divisions: []} = league) do
        Enum.each(conferences, &with_teams(&1))

        league
      end
    end
  end
end
