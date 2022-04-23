defmodule OOTPUtility.Statistics.Calculations do
  alias OOTPUtility.Statistics.{Batting, Pitching}

  @batting_stats [
    :hits,
    :batting_average,
    :batting_average_on_balls_in_play,
    :plate_appearances,
    :extra_base_hits,
    :isolated_power,
    :on_base_percentage,
    :on_base_plus_slugging,
    :runs_created,
    :singles,
    :slugging,
    :stolen_base_percentage,
    :total_bases
  ]

  @pitching_stats [
    :blown_save_percentage,
    :complete_game_percentage,
    :earned_run_average,
    :games_finished_percentage,
    :ground_ball_percentage,
    :hits_per_9,
    :home_runs_per_9,
    :inherited_runners_scored_percentage,
    :pitches_per_game,
    :quality_start_percentage,
    :run_support_per_start,
    :runs_per_9,
    :save_percentage,
    :strikeouts_per_9,
    :strikeouts_to_walks_ratio,
    :walks_hits_per_inning_pitched,
    :walks_per_9,
    :winning_percentage
  ]

  @one_digit_precision [
    :blown_save_percentage,
    :complete_game_percentage,
    :games_finished_percentage,
    :ground_ball_percentage,
    :inherited_runners_scored_percentage,
    :pitches_per_game,
    :quality_start_percentage,
    :run_support_per_start,
    :runs_created,
    :runs_created_per_27_outs,
    :save_percentage,
    :stolen_base_percentage,
    :ubr,
    :winning_percentage,
    :wins_above_replacement
  ]

  @two_digit_precision [
    :earned_run_average,
    :fielding_independent_pitching,
    :hits_per_9,
    :leverage_index,
    :runs_per_9,
    :home_runs_per_9,
    :strikeouts_per_9,
    :strikeouts_to_walks_ratio,
    :walks_hits_per_inning_pitched,
    :walks_per_9,
    :win_probability_added
  ]

  @three_digit_precision [
    :batting_average,
    :batting_average_on_balls_in_play,
    :isolated_power,
    :on_base_percentage,
    :on_base_plus_slugging,
    :slugging,
    :weighted_on_base_average
  ]

  def calculate(attrs, stat) do
    attrs
    |> do_calculate(stat)
    |> do_round(stat)
  end

  def round(value, stat), do: do_round(value, stat)

  def do_calculate(attrs, stat) when stat in @batting_stats,
    do: Batting.Calculations.calculate(attrs, stat)

  def do_calculate(attrs, stat) when stat in @pitching_stats,
    do: Pitching.Calculations.calculate(attrs, stat)

  def do_calculate(attrs, stat), do: Map.get(attrs, stat)

  defp do_round(value, stat) when stat in @one_digit_precision do
    Float.round(value, 1)
  end

  defp do_round(value, stat) when stat in @two_digit_precision do
    Float.round(value, 2)
  end

  defp do_round(value, stat) when stat in @three_digit_precision do
    Float.round(value, 3)
  end

  defp do_round(value, _stat_name), do: value
end
