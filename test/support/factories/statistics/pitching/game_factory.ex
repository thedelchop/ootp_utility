defmodule OOTPUtility.Statistics.Pitching.GameFactory do
  alias OOTPUtility.Statistics.Pitching
  alias __MODULE__

  import OOTPUtility.Statistics, only: [calculate: 2]

  defmacro __using__(_opts) do
    quote do
      def game_pitching_stats_factory(attrs) do
        player = Map.get_lazy(attrs, :player, fn -> insert(:player) end)
        team = Map.get(attrs, :team, player.team)
        league = Map.get(attrs, :league, team.league)

        game =
          Map.get_lazy(attrs, :game, fn ->
            insert(:game, home_team: team, date: league.current_date)
          end)

        default_attrs =
          GameFactory.counting_stats_for_game()
          |> GameFactory.add_rate_statistics()
          |> Enum.into(%{
            id: sequence(:id, &"#{&1}"),
            position: player.position,
            league: league,
            player: player,
            team: team,
            game: game
          })
          |> Map.delete(:put_outs)

        Pitching.Game
        |> struct!(default_attrs)
        |> merge_attributes(attrs)
        |> evaluate_lazy_attributes()
      end
    end
  end

  def counting_stats_for_game() do
    %{
      balks: generate_random_outcome(:impossible),
      blown_saves: generate_random_outcome(:impossible),
      catchers_interference: generate_random_outcome(:impossible),
      caught_stealing: generate_random_outcome(:unlikely),
      complete_games: WeightedRandom.complex([%{value: 0, weight: 99}, %{value: 1, weight: 1}]),
      double_plays: generate_random_outcome(:unlikely),
      doubles: generate_random_outcome(:unlikely),
      earned_runs: generate_random_outcome(:rare),
      fly_balls: generate_random_outcome(:unlikely),
      games: 1,
      games_started: 1,
      ground_balls: generate_random_outcome(:rare),
      hit_by_pitch: generate_random_outcome(:rare),
      home_runs: generate_random_outcome(:very_unlikely),
      inherited_runners: generate_random_outcome(:very_unlikely),
      inherited_runners_scored: generate_random_outcome(:very_unlikely),
      intentional_walks: generate_random_outcome(:rare),
      leverage_index: 1.00,
      runs: generate_random_outcome(:unlikely),
      runs_batted_in: generate_random_outcome(:unlikely),
      sacrifice_flys: generate_random_outcome(:rare),
      sacrifices: generate_random_outcome(:rare),
      singles: generate_random_outcome(:common),
      stolen_bases: generate_random_outcome(:unlikely),
      strikeouts: generate_random_outcome(:common),
      triples: generate_random_outcome(:very_unlikely),
      walks: generate_random_outcome(:common),
      win_probability_added: 0.0,
      put_outs:
        WeightedRandom.complex([
          %{value: 0, weight: 5},
          %{value: 1, weight: 15},
          %{value: 2, weight: 40},
          %{value: 3, weight: 30},
          %{value: 4, weight: 8},
          %{value: 4, weight: 2}
        ])
    }
    |> do_counting_stats_for_game()
  end

  def add_rate_statistics(counting_stats) do
    Enum.into(counting_stats, %{
      batting_average: calculate(counting_stats, :batting_average),
      batting_average_on_balls_in_play:
        calculate(counting_stats, :batting_average_on_balls_in_play),
      blown_save_percentage: calculate(counting_stats, :blown_save_percentage),
      complete_game_percentage: calculate(counting_stats, :complete_game_percentage),
      earned_run_average: calculate(counting_stats, :earned_run_average),
      extra_base_hits: calculate(counting_stats, :extra_base_hits),
      isolated_power: calculate(counting_stats, :isolated_power),
      games_finished_percentage: calculate(counting_stats, :isolated_power),
      ground_ball_percentage: calculate(counting_stats, :isolated_power),
      on_base_percentage: calculate(counting_stats, :on_base_percentage),
      on_base_plus_slugging: calculate(counting_stats, :on_base_plus_slugging),
      runs_created: calculate(counting_stats, :runs_created),
      slugging: calculate(counting_stats, :slugging),
      stolen_base_percentage: calculate(counting_stats, :stolen_base_percentage)
    })
  end

  def do_counting_stats_for_game(stats) when not is_map_key(stats, :hits) do
    stats
    |> Map.put(:hits, calculate(stats, :hits))
    |> do_counting_stats_for_game()
  end

  def do_counting_stats_for_game(
        %{put_outs: put_outs, strikeouts: strikeouts, double_plays: double_plays} = stats
      )
      when not is_map_key(stats, :at_bats) do
    hits = calculate(stats, :hits)

    stats
    |> Map.put(:at_bats, hits + put_outs + strikeouts + double_plays)
    |> do_counting_stats_for_game()
  end

  def do_counting_stats_for_game(stats)
      when not is_map_key(stats, :plate_appearances) do
    stats
    |> Map.put(:plate_appearances, calculate(stats, :plate_appearances))
    |> do_counting_stats_for_game()
  end

  def do_counting_stats_for_game(stats) when not is_map_key(stats, :total_bases) do
    stats
    |> Map.put(:total_bases, calculate(stats, :total_bases))
    |> do_counting_stats_for_game()
  end

  def do_counting_stats_for_game(stats), do: stats

  defp generate_random_outcome(:common) do
    WeightedRandom.complex([
      %{value: 0, weight: 71},
      %{value: 1, weight: 13},
      %{value: 2, weight: 8},
      %{value: 3, weight: 5},
      %{value: 4, weight: 3}
    ])
  end

  defp generate_random_outcome(:unlikely) do
    WeightedRandom.complex([
      %{value: 0, weight: 85},
      %{value: 1, weight: 7},
      %{value: 2, weight: 5},
      %{value: 3, weight: 2},
      %{value: 4, weight: 1}
    ])
  end

  defp generate_random_outcome(:very_unlikely) do
    WeightedRandom.complex([
      %{value: 0, weight: 95},
      %{value: 1, weight: 2},
      %{value: 2, weight: 2},
      %{value: 3, weight: 1}
    ])
  end

  defp generate_random_outcome(:rare) do
    WeightedRandom.complex([
      %{value: 0, weight: 95},
      %{value: 1, weight: 4},
      %{value: 2, weight: 1}
    ])
  end

  defp generate_random_outcome(:impossible) do
    WeightedRandom.complex([
      %{value: 0, weight: 99},
      %{value: 1, weight: 1},
      %{value: 2, weight: 1}
    ])
  end
end
