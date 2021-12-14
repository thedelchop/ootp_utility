defmodule OOTPUtility.Statistics.BattingFactory do
  alias OOTPUtility.Statistics.Batting

  defmacro __using__(_opts) do
    quote do
      def team_batting_stats_factory do
        struct!(
          batting_stats_factory(Batting.Team, 10),
          %{
            weighted_on_base_average: 0.300,
            runs_created_per_27_outs: 3.750
          }
        )
      end

      def player_batting_stats_factory do
        struct!(
          batting_stats_factory(Batting.Player),
          %{
            wins_above_replacement: 1.00,
            split_id: 1,
            pitches_seen: 1000,
            player: fn s ->
              build(:player, team: s.team, league: s.league)
            end
          }
        )
      end

      # As a quick way to generate reasonable batting statistiscs for both a team's season and player's season,
      # provide a "num_of_players" parameter that defaults to 1, but could be passed something like 10 to approixmate
      # a Team's batting statistics

      defp batting_stats_factory(module, num_of_players \\ 1) do
        at_bats = Faker.random_between(520, 550) * num_of_players
        singles = Faker.random_between(85, 90) * num_of_players
        doubles = Faker.random_between(20, 35) * num_of_players
        triples = Faker.random_between(1, 10) * num_of_players
        home_runs = Faker.random_between(10, 45) * num_of_players

        runs = Faker.random_between(60, 120) * num_of_players

        stolen_bases = Faker.random_between(0, 40) * num_of_players
        stolen_base_percentage = Faker.random_uniform()

        walks = Faker.random_between(20, 150) * num_of_players
        intentional_walks = Faker.random_between(0, 10) * num_of_players
        hit_by_pitch = Faker.random_between(2, 10) * num_of_players

        sacrifice_flys = Faker.random_between(2, 16) * num_of_players

        struct!(module, %{
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
          strikeouts: Faker.random_between(75, 160) * num_of_players,
          walks: walks,
          intentional_walks: intentional_walks,
          hit_by_pitch: hit_by_pitch,
          catchers_interference: Faker.random_between(0, 2) * num_of_players,
          runs: runs,
          runs_batted_in: fn s -> ceil(s.runs * 0.955) end,
          double_plays: Faker.random_between(5, 15) * num_of_players,
          sacrifice_flys: sacrifice_flys,
          sacrifices: Faker.random_between(2, 5) * num_of_players,
          stolen_bases: stolen_bases,
          stolen_base_percentage: stolen_base_percentage,
          caught_stealing: fn s ->
            (s.stolen_bases / stolen_base_percentage) |> round() |> trunc()
          end,
          batting_average: fn s -> batting_average(s) end,
          batting_average_on_balls_in_play: 0.300,
          isolated_power: fn s -> isolated_power(s) end,
          on_base_percentage: fn s -> obp(s) end,
          on_base_plus_slugging: fn s -> obp(s) + slg(s) end,
          slugging: fn s -> slg(s) end,
          runs_created: fn s -> runs_created(s) end,
          league: fn -> build(:league) end,
          team: fn s -> build(:team, league: s.league) end
        })
      end

      def batting_average(%{at_bats: ab} = stats), do: do_round(hits(stats) / ab)

      def isolated_power(%{at_bats: ab} = stats),
        do: do_round((total_bases(stats) - hits(stats)) / ab)

      def hits(%{
            singles: singles,
            doubles: doubles,
            triples: triples,
            home_runs: home_runs
          }) do
        singles + doubles + triples + home_runs
      end

      def total_bases(%{
            singles: singles,
            doubles: doubles,
            triples: triples,
            home_runs: home_runs
          }) do
        singles + 2 * doubles + 3 * triples + 4 * home_runs
      end

      def obp(%{walks: bb, hit_by_pitch: hbp, at_bats: ab, sacrifice_flys: sf} = stats) do
        do_round((hits(stats) + bb + hbp) / (ab + bb + hbp + sf))
      end

      def slg(%{at_bats: ab} = stats) do
        do_round(total_bases(stats) / ab)
      end

      def runs_created(%{walks: bb, at_bats: ab} = stats) do
        do_round((hits(stats) + bb) * total_bases(stats) / (ab + bb))
      end

      defp do_round(value), do: Float.round(value, 4)
    end
  end
end
