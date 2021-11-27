defmodule OOTPUtility.Statistics.BattingFactory do
  alias OOTPUtility.Statistics.Batting

  defmacro __using__(_opts) do
    quote do
      def team_batting_stats_factory do
        at_bats = Faker.random_between(5200, 5500)
        singles = Faker.random_between(850, 900)
        doubles = Faker.random_between(200, 350)
        triples = Faker.random_between(11, 37)
        home_runs = Faker.random_between(125, 275)

        runs = Faker.random_between(600, 1000)

        stolen_bases = Faker.random_between(30, 150)
        caught_stealing = Faker.random_between(10, 50)

        walks = Faker.random_between(400, 650)
        intentional_walks = Faker.random_between(5, 50)
        hit_by_pitch = Faker.random_between(40, 110)

        sacrifice_flys = Faker.random_between(20, 60)

        %Batting.Team{
          id: sequence(:id, &"#{&1}"),
          level_id: 1,
          year: fn s -> s.league.season_year end,
          games: 162,
          games_started: fn stats -> stats.games end,
          at_bats: at_bats,
          plate_appearances: fn s -> ceil(s.at_bats * 1.124) end,
          hits: fn s -> hits(s) end,
          singles: singles,
          doubles: doubles,
          triples: triples,
          home_runs: home_runs,
          extra_base_hits: fn s -> s.doubles + s.triples + s.home_runs end,
          total_bases: fn s -> total_bases(s) end,
          strikeouts: Faker.random_between(1200, 1600),
          walks: walks,
          intentional_walks: intentional_walks,
          hit_by_pitch: hit_by_pitch,
          catchers_interference: Faker.random_between(1, 10),
          runs: runs,
          runs_batted_in: fn s -> ceil(s.runs * 0.955) end,
          double_plays: Faker.random_between(75, 150),
          sacrifice_flys: sacrifice_flys,
          sacrifices: Faker.random_between(5, 50),
          stolen_bases: stolen_bases,
          caught_stealing: caught_stealing,
          batting_average: fn s -> batting_average(s) end,
          isolated_power: fn s -> isolated_power(s) end,
          on_base_percentage: fn s -> obp(s) end,
          on_base_plus_slugging: fn s -> obp(s) + slg(s) end,
          slugging: fn s -> slg(s) end,
          stolen_base_percentage: fn s ->
            s.stolen_bases / (s.stolen_bases + s.caught_stealing)
          end,
          runs_created: fn s -> runs_created(s) end,
          league: fn -> build(:league) end,
          team: fn s -> build(:team, league: s.league) end
        }
      end

      def batting_average(%Batting.Team{at_bats: ab} = stats), do: do_round(hits(stats) / ab)

      def isolated_power(%Batting.Team{at_bats: ab} = stats),
        do: do_round((total_bases(stats) - hits(stats)) / ab)

      def hits(%Batting.Team{
            singles: singles,
            doubles: doubles,
            triples: triples,
            home_runs: home_runs
          }) do
        singles + doubles + triples + home_runs
      end

      def total_bases(%Batting.Team{
            singles: singles,
            doubles: doubles,
            triples: triples,
            home_runs: home_runs
          }) do
        singles + 2 * doubles + 3 * triples + 4 * home_runs
      end

      def obp(
            %Batting.Team{walks: bb, hit_by_pitch: hbp, at_bats: ab, sacrifice_flys: sf} = stats
          ) do
        do_round((hits(stats) + bb + hbp) / (ab + bb + hbp + sf))
      end

      def slg(%Batting.Team{at_bats: ab} = stats) do
        do_round(total_bases(stats) / ab)
      end

      def runs_created(%Batting.Team{walks: bb, at_bats: ab} = stats) do
        do_round((hits(stats) + bb) * total_bases(stats) / (ab + bb))
      end

      defp do_round(value), do: Float.round(value, 4)
    end
  end
end
