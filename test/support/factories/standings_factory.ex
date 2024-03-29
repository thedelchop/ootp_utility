defmodule OOTPUtility.StandingsFactory do
  alias OOTPUtility.{Leagues, Standings}

  import OOTPUtility.Factories.Utilities,
    only: [distribute_wins_amongst_teams: 2, generate_slug_from_name: 1]

  defmacro __using__(_opts) do
    # credo:disable-for-next-line Credo.Check.Refactor.LongQuoteBlocks
    quote do
      def team_standings_factory(%{team: team} = attrs) do
        attrs
        |> Map.put(:name, team.name)
        |> Map.put(:abbr, team.abbr)
        |> Map.put(:logo_filename, team.logo_filename)
        |> Map.put(:slug, team.slug)
        |> do_team_standings_factory()
      end

      def team_standings_factory(attrs), do: do_team_standings_factory(attrs)

      def do_team_standings_factory(attrs) do
        games = Map.get(attrs, :games, Faker.random_between(1, 162))
        wins = Map.get(attrs, :wins, Faker.random_between(1, games))

        standings =
          %Standings.Team{
            name: sequence("Test Team"),
            slug: fn s -> generate_slug_from_name(s) end,
            abbr: "TT",
            logo_filename: "my_team.png",
            games: games,
            wins: wins,
            losses: games - wins,
            winning_percentage: wins / games,
            games_behind: 3,
            magic_number: 3,
            position: 1,
            streak: 3
          }
          |> merge_attributes(attrs)
          |> evaluate_lazy_attributes()

        team =
          Map.get_lazy(attrs, :team, fn ->
            insert(:team,
              name: standings.name,
              abbr: standings.abbr,
              logo_filename: standings.logo_filename,
              slug: standings.slug
            )
          end)

        standings =
          standings
          |> Map.put(:team, team)

        team_record_options =
          standings
          |> Map.from_struct()
          |> Map.take([
            :games,
            :wins,
            :losses,
            :winning_percentage,
            :magic_number,
            :position,
            :streak
          ])
          |> Map.to_list()

        insert(:team_record, team_record_options)

        standings
      end

      def division_standings_factory(attrs) do
        games = Map.get(attrs, :games, Faker.random_between(1, 162))
        division = Map.get_lazy(attrs, :division, fn -> insert(:division) end)

        %Standings.Division{
          id: fn ds -> "#{ds.division.slug}-standings" end,
          division: division,
          team_standings: fn
            ds ->
              distribute_wins_amongst_teams(5, games)
              |> Enum.map(
                &insert(:team_standings,
                  wins: &1,
                  games: games,
                  team:
                    insert(:team,
                      division: division,
                      conference: division.conference,
                      league: division.league
                    )
                )
              )
          end
        }
        |> merge_attributes(attrs)
        |> evaluate_lazy_attributes()
      end

      def conference_standings_factory(attrs) do
        games = Map.get(attrs, :games, Faker.random_between(1, 162))

        attrs
        |> Map.get_lazy(:conference, fn -> build(:conference) end)
        |> do_conference_standings_factory(games)
        |> merge_attributes(attrs)
        |> evaluate_lazy_attributes()
      end

      def league_standings_factory(attrs) do
        games = Map.get(attrs, :games, Faker.random_between(1, 162))

        attrs
        |> Map.get_lazy(:league, fn -> build(:league) end)
        |> do_league_standings_factory(games)
        |> merge_attributes(attrs)
        |> evaluate_lazy_attributes()
      end

      defp do_conference_standings_factory(%Leagues.Conference{divisions: []} = conference, games) do
        %Standings.Conference{
          id: "#{conference.slug}-standings",
          conference: conference,
          team_standings:
            build_list(5, :team_standings,
              games: games,
              team: fn ->
                build(:team, division: nil, conference: conference, league: conference.league)
              end
            )
        }
      end

      defp do_conference_standings_factory(conference, games) do
        %Standings.Conference{
          id: "#{conference.slug}-standings",
          conference: conference,
          division_standings:
            build_list(3, :division_standings,
              games: games,
              division: fn ->
                build(:division, conference: conference, league: conference.league)
              end
            )
        }
      end

      defp do_league_standings_factory(%Leagues.League{conferences: []} = league, games) do
        %Standings.League{
          id: "#{league.slug}-standings",
          league: league,
          division_standings:
            build_list(3, :division_standings,
              games: games,
              division: fn ->
                build(:division, league: league, conference: nil)
              end
            )
        }
      end

      defp do_league_standings_factory(league, games) do
        %Standings.League{
          id: "#{league.slug}-standings",
          league: league,
          conference_standings:
            build_pair(:conference_standings,
              games: games,
              conference: fn ->
                build(:conference, league: league)
              end
            )
        }
      end
    end
  end
end
