defmodule OOTPUtility.Statistics.Calculations do
  alias OOTPUtility.Statistics.{Batting, Pitching}

  @batting_stats [
    :extra_base_hits,
    :isolated_power,
    :runs_created,
    :singles,
    :stolen_base_percentage
  ]

  @pitching_stats [
    :blown_save_percentage,
    :complete_game_percentage,
    :earned_run_average,
    :games_finished_percentage,
    :ground_ball_percentage,
    :hits_per_9,
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

  def do_calculate(%{at_bats: 0}, :batting_average), do: 0.0

  def do_calculate(%{hits: h, at_bats: ab}, :batting_average) do
    h / ab
  end

  def do_calculate(
        %{
          hits: h,
          home_runs: hr,
          at_bats: ab,
          strikeouts: k,
          sacrifice_flys: sf
        } = _attrs,
        :batting_average_on_balls_in_play
      ) do
    balls_in_play = ab - k - hr - sf

    if balls_in_play > 0 do
      (h - hr) / balls_in_play
    else
      0.0
    end
  end

  def do_calculate(
        %{
          at_bats: ab,
          hits: h,
          walks: bb,
          hit_by_pitch: hbp,
          sacrifice_flys: sf
        },
        :on_base_percentage
      ) do
    on_base_attempts = ab + bb + hbp + sf

    if on_base_attempts == 0, do: 0.0, else: (h + bb + hbp) / on_base_attempts
  end

  def do_calculate(%{at_bats: 0}, :slugging), do: 0.0

  def do_calculate(
        %{
          at_bats: ab
        } = attrs,
        :slugging
      ) do
    total_bases = calculate(attrs, :total_bases)
    total_bases / ab
  end

  def do_calculate(
        %{
          singles: s,
          doubles: d,
          triples: t,
          home_runs: hr
        },
        :total_bases
      ) do
    s + 2 * d + 3 * t + 4 * hr
  end

  def do_calculate(attrs, :on_base_plus_slugging) do
    calculate(attrs, :on_base_percentage) + calculate(attrs, :slugging)
  end

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
