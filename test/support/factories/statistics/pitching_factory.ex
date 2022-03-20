defmodule OOTPUtility.Statistics.PitchingFactory do
  import OOTPUtility.Statistics, only: [calculate: 2]

  alias OOTPUtility.Statistics.Pitching

  defmacro __using__(_opts) do
    quote do
      def team_pitching_stats_factory do
        struct!(
          pitching_stats_factory(Pitching.Team, 10),
          %{
            fielding_independent_pitching: 2.75
          }
        )
      end

      def player_pitching_stats_factory(attrs) do
        player = Map.get_lazy(attrs, :player, fn -> insert(:player) end)
        team = Map.get(attrs, :team, player.team)
        league = Map.get(attrs, :league, team.league)

        Pitching.Player
        |> pitching_stats_factory()
        |> struct!(%{
          league: league,
          player: player,
          team: team,
          split: :all,
          inherited_runners: 0,
          inherited_runners_scored: 0,
          inherited_runners_scored_percentage: 0,
          leverage_index: 0,
          win_probability_added: 0
        })
        |> merge_attributes(Map.drop(attrs, [:player, :team, :league]))
        |> evaluate_lazy_attributes()
      end

      # As a quick way to generate reasonable pitching statistics for both a team's season and player's season,
      # provide a "num_of_players" parameter that defaults to 1, but could be passed something like 10 to approximate
      # a Team's pitching statistics

      defp pitching_stats_factory(module, num_of_players \\ 1) do
        at_bats = Faker.random_between(520, 550) * num_of_players
        singles = Faker.random_between(85, 90) * num_of_players
        doubles = Faker.random_between(20, 35) * num_of_players
        triples = Faker.random_between(1, 10) * num_of_players
        home_runs = Faker.random_between(10, 45) * num_of_players
        hits = singles + doubles + triples + home_runs

        runs = Faker.random_between(60, 120) * num_of_players

        stolen_bases = Faker.random_between(0, 40) * num_of_players
        stolen_base_percentage = Faker.random_uniform()

        walks = Faker.random_between(30, 150) * num_of_players
        intentional_walks = Faker.random_between(0, 10) * num_of_players
        hit_by_pitch = Faker.random_between(2, 10) * num_of_players

        sacrifice_flys = Faker.random_between(2, 16) * num_of_players

        games = (Faker.random_between(5, 25) * num_of_players) |> min(162)
        quality_starts = Faker.random_between(0, games)
        wins = Faker.random_between(quality_starts, (games * 0.75) |> round() |> trunc())

        struct!(module, %{
          id: sequence(:id, &"#{&1}"),
          level: :major,
          at_bats: at_bats,
          balks: Faker.random_between(0, 2) * num_of_players,
          batting_average: fn s -> calculate(s, :batting_average) end,
          batting_average_on_balls_in_play: fn s ->
            calculate(s, :batting_average_on_balls_in_play)
          end,
          blown_saves: 0,
          blown_save_percentage: fn s -> calculate(s, :blown_save_percentage) end,
          catchers_interference: Faker.random_between(1, 10),
          caught_stealing: fn s ->
            (s.stolen_bases / stolen_base_percentage) |> round() |> trunc()
          end,
          complete_games: Faker.random_between(0, 5) * num_of_players,
          complete_game_percentage: fn s -> calculate(s, :complete_game_percentage) end,
          double_plays: Faker.random_between(5, 15) * num_of_players,
          doubles: doubles,
          earned_run_average: fn s -> calculate(s, :earned_run_average) end,
          earned_runs: Faker.random_between(45, 80) * num_of_players,
          fly_balls: Faker.random_between(125, 160 * num_of_players),
          games: games,
          games_finished: 0,
          games_started: games,
          games_finished_percentage: fn s -> calculate(s, :games_finished_percentage) end,
          ground_balls: Faker.random_between(125, 160) * num_of_players,
          ground_ball_percentage: fn s -> calculate(s, :ground_ball_percentage) end,
          hit_by_pitch: hit_by_pitch,
          hits: hits,
          hits_per_9: fn s -> calculate(s, :hits_per_9) end,
          holds: 0,
          home_runs: home_runs,
          home_runs_per_9: fn s -> calculate(s, :home_runs_per_9) end,
          intentional_walks: intentional_walks,
          on_base_percentage: fn s -> calculate(s, :on_base_percentage) end,
          on_base_plus_slugging: fn s -> calculate(s, :on_base_plus_slugging) end,
          outs_pitched: Faker.random_between(375, 550) * num_of_players,
          pitches_per_game: fn s -> calculate(s, :pitches_per_game) end,
          pitches_thrown: Faker.random_between(2000, 2300) * num_of_players,
          plate_appearances: fn s -> ceil(s.at_bats * 1.124) end,
          quality_starts: quality_starts,
          quality_start_percentage: fn s -> calculate(s, :quality_start_percentage) end,
          relief_appearances: 0,
          run_support: fn s -> (s.run_support_per_start * s.games) |> round() |> trunc() end,
          run_support_per_start: 3.0 + Faker.random_uniform(),
          runs_per_9: fn s -> calculate(s, :runs_per_9) end,
          runs: runs,
          sacrifice_flys: sacrifice_flys,
          sacrifices: Faker.random_between(1, 7) * num_of_players,
          save_opportunities: 0,
          save_percentage: fn s -> calculate(s, :save_percentage) end,
          saves: 0,
          shutouts: 0,
          singles: singles,
          slugging: fn s -> calculate(s, :slugging) end,
          stolen_bases: stolen_bases,
          strikeouts: Faker.random_between(70, 200) * num_of_players,
          strikeouts_per_9: fn s -> calculate(s, :strikeouts_per_9) end,
          strikeouts_to_walks_ratio: fn s -> calculate(s, :strikeouts_to_walks_ratio) end,
          total_bases: fn s -> calculate(s, :total_bases) end,
          triples: triples,
          walks: walks,
          walks_per_9: fn s -> calculate(s, :walks_per_9) end,
          walks_hits_per_inning_pitched: fn s -> calculate(s, :walks_hits_per_inning_pitched) end,
          wild_pitches: Faker.random_between(3, 7) * num_of_players,
          winning_percentage: fn s -> calculate(s, :winning_percentage) end,
          wins: wins,
          year: fn s -> s.league.season_year end,
          team: fn s -> build(:team, league: s.league) end,
          league: fn -> build(:league) end
        })
      end
    end
  end
end
