defmodule OOTPUtility.ConferenceFactory do
  alias OOTPUtility.{Leagues, Repo}
  import OOTPUtility.Factories.Utilities, only: [generate_slug_from_name: 1]

  defmacro __using__(_opts) do
    quote do
      def conference_factory do
        %Leagues.Conference{
          id: sequence(:id, &"#{&1}"),
          name: sequence("Test Conference"),
          slug: &generate_slug_from_name/1,
          abbr: "TC",
          designated_hitter: true,
          league: fn -> build(:league) end
        }
      end

      def with_divisions(%Leagues.Conference{league: league} = conference) do
        insert_pair(:division, league: league, conference: conference)

        Repo.preload(conference, [divisions: [:league, :conference]])
      end

      def with_teams(%Leagues.Conference{divisions: %Ecto.Association.NotLoaded{}} = conference) do
        conference
        |> Repo.preload([:divisions, :league])
        |> with_teams()
      end

      def with_teams(%Leagues.Conference{league: %Ecto.Association.NotLoaded{}} = conference) do
        conference
        |> Repo.preload(:league)
        |> with_teams()
      end

      def with_teams(%Leagues.Conference{divisions: [], league: league} = conference) do
        build_list(4, :team, league: league, conference: conference, division: nil)

        Repo.preload(conference, :teams)
      end

      def with_teams(%Leagues.Conference{divisions: divisions, league: league} = conference) do
        Enum.each(divisions, &build_list(4, :team, division: &1, conference: conference, league: league))

        Repo.preload(conference, divisions: [:teams])
      end
    end
  end
end
