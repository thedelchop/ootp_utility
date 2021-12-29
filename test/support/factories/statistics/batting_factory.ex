defmodule OOTPUtility.Statistics.BattingFactory do
  alias OOTPUtility.Statistics.Batting
  import OOTPUtility.Statistics, only: [calculate: 2]

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
            split: :all,
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
        hits = singles + doubles + triples + home_runs

        runs = Faker.random_between(60, 120) * num_of_players

        stolen_bases = Faker.random_between(0, 40) * num_of_players
        stolen_base_percentage = Faker.random_uniform()
        caught_stealing = (stolen_bases / stolen_base_percentage) |> round() |> trunc()

        walks = Faker.random_between(20, 150) * num_of_players
        intentional_walks = Faker.random_between(0, 10) * num_of_players
        hit_by_pitch = Faker.random_between(2, 10) * num_of_players

        sacrifice_flys = Faker.random_between(2, 16) * num_of_players

        struct!(module, %{
          id: sequence(:id, &"#{&1}"),
          level: :major,
          at_bats: at_bats,
          batting_average: fn s -> calculate(s, :batting_average) end,
          batting_average_on_balls_in_play: fn s ->
            calculate(s, :batting_average_on_balls_in_play)
          end,
          catchers_interference: Faker.random_between(0, 2) * num_of_players,
          caught_stealing: caught_stealing,
          double_plays: Faker.random_between(5, 15) * num_of_players,
          doubles: doubles,
          extra_base_hits: fn s -> s.doubles + s.triples + s.home_runs end,
          games: 162,
          games_started: fn stats -> stats.games end,
          hit_by_pitch: hit_by_pitch,
          hits: hits,
          home_runs: home_runs,
          intentional_walks: intentional_walks,
          isolated_power: fn s -> calculate(s, :isolated_power) end,
          on_base_percentage: fn s -> calculate(s, :on_base_percentage) end,
          on_base_plus_slugging: fn s -> calculate(s, :on_base_plus_slugging) end,
          plate_appearances: fn s -> ceil(s.at_bats * 1.124) end,
          runs: runs,
          runs_batted_in: fn s -> ceil(s.runs * 0.955) end,
          runs_created: fn s -> calculate(s, :runs_created) end,
          sacrifice_flys: sacrifice_flys,
          sacrifices: Faker.random_between(2, 5) * num_of_players,
          singles: singles,
          slugging: fn s -> calculate(s, :slugging) end,
          stolen_base_percentage: stolen_base_percentage,
          stolen_bases: stolen_bases,
          strikeouts: Faker.random_between(75, 160) * num_of_players,
          team: fn s -> build(:team, league: s.league) end,
          total_bases: fn s -> calculate(s, :total_bases) end,
          triples: triples,
          walks: walks,
          year: fn s -> s.league.season_year end,
          league: fn -> build(:league) end
        })
      end
    end
  end
end
