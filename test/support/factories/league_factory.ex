defmodule OOTPUtility.LeagueFactory do
  alias OOTPUtility.{Leagues, Repo}
  import OOTPUtility.Factories.Utilities, only: [generate_slug_from_name: 1]

  defmacro __using__(_opts) do
    quote do
      def league_factory do
        %Leagues.League{
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

      def with_conferences(%Leagues.League{} = league) do
        insert_pair(:conference, league: league)

        Repo.preload(league, [conferences: [divisions: [:league, :conference]]])
      end

      def with_divisions(%Leagues.League{} = league) do
        insert_pair(:division, league: league, conference: nil)

        Repo.preload(league, [:conferences, divisions: [:league, :conference]])
      end

      def with_teams(%Leagues.League{conferences: [], divisions: []} = league) do
        build_list(4, :team, league: league)

        Repo.preload(league, :teams)
      end

      def with_teams(%Leagues.League{conferences: [], divisions: divisions} = league) do
        Enum.each(divisions, &with_teams(&1))

        Repo.preload(league, divisions: [:teams])
      end

      def with_teams(%Leagues.League{conferences: conferences} = league) do
        Enum.each(conferences, &with_teams(&1))

        Repo.preload(league, conferences: [:teams])
      end
    end
  end
end
