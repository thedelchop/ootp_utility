defmodule OOTPUtility.ConferenceFactory do
  alias OOTPUtility.{Leagues, Repo}

  defmacro __using__(_opts) do
    quote do
      def conference_factory do
        %Leagues.Conference{
          id: sequence(:id, &"#{&1}"),
          name: sequence("Test Conference"),
          slug: fn c -> generate_slug_from_name(c) end,
          abbr: "TC",
          designated_hitter: true,
          league: fn -> build(:league) end
        }
      end

      def with_conferences(%Leagues.League{} = league, number_of_conferences \\ 2) do
        insert_list(number_of_conferences, :conference, league: league)

        Repo.preload(league, conferences: [divisions: [:league, :conference]])
      end
    end
  end
end
