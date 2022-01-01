defmodule OOTPUtility.LeagueFactory do
  alias OOTPUtility.Leagues
  import OOTPUtility.Factories.Utilities, only: [generate_slug_from_name: 1]

  defmacro __using__(_opts) do
    quote do
      def league_factory do
        %Leagues.League{
          id: sequence(:id, &"#{&1}"),
          name: sequence(:name, &"Test League #{&1}"),
          slug: fn l -> generate_slug_from_name(l) end,
          abbr: "TL",
          current_date: ~D[2021-09-05],
          level: :major,
          logo_filename: "test_league.png",
          season_year: 2021,
          start_date: ~D[2021-09-05]
        }
      end
    end
  end
end
