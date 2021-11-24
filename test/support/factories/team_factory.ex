defmodule OOTPUtility.TeamFactory do
  alias OOTPUtility.Teams.Team

  import OOTPUtility.Factories.Utilities, only: [generate_slug_from_name: 1]

  defmacro __using__(_opts) do
    quote do
      def team_factory do
        %Team{
          id: sequence(:id, &"#{&1}"),
          name: sequence("Test Team"),
          slug: &generate_slug_from_name/1,
          abbr: "TT",
          level: "1",
          logo_filename: "my_team.png",
          league: fn -> build(:league) end,
          conference: fn team -> build(:conference, league: team.league) end,
          division: fn team ->
            build(:division, conference: team.conference, league: team.league)
          end
        }
      end
    end
  end
end
