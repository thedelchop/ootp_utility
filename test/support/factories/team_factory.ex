defmodule OOTPUtility.TeamFactory do
  alias OOTPUtility.Teams.Team

  import OOTPUtility.Factories.Utilities, only: [generate_slug_from_name: 1]

  defmacro __using__(_opts) do
    quote do
      def team_factory(attrs) do
        level = Map.get(attrs, :level, :major)
        league = Map.get_lazy(attrs, :league, fn -> insert(:league, league_level: level) end)

        conference =
          Map.get_lazy(attrs, :conference, fn -> insert(:conference, league: league) end)

        division =
          Map.get_lazy(attrs, :division, fn ->
            build(:division, conference: conference, league: league)
          end)

        team = %Team{
          id: sequence(:id, &"#{&1}"),
          name: sequence("Test Team"),
          slug: &generate_slug_from_name/1,
          abbr: "TT",
          level: :major,
          logo_filename: "my_team.png",
          organization: nil,
          league: league,
          conference: conference,
          division: division
        }

        team
        |> merge_attributes(attrs)
        |> evaluate_lazy_attributes()
      end
        }
      end
    end
  end
end
