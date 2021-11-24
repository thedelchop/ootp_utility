defmodule OOTPUtility.ConferenceFactory do
  alias OOTPUtility.Leagues.Conference
  import OOTPUtility.Factories.Utilities, only: [generate_slug_from_name: 1]

  defmacro __using__(_opts) do
    quote do
      def conference_factory do
        %Conference{
          id: sequence(:id, &"#{&1}"),
          name: sequence("Test Conference"),
          slug: &generate_slug_from_name/1,
          abbr: "TC",
          designated_hitter: true,
          league: fn -> build(:league) end
        }
      end

      def with_divisions(%Conference{} = conference) do
        insert_pair(:division, conference: conference)

        conference
      end

      def with_teams(%Conference{divisions: [], league: league} = conference) do
        build_list(4, :team, league: league, conference: conference)

        conference
      end

      def with_teams(%Conference{divisions: divisions} = conference) do
        Enum.each(divisions, &build_list(4, :team, division: &1, conference: conference))

        conference
      end
    end
  end
end
