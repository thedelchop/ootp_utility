defmodule OOTPUtility.Statistics.Pitching.Calculations do
  def calculate(%{save_opportunities: 0} = _attrs, :blown_save_percentage), do: 0.0

  def calculate(%{blown_saves: bs, save_opportunities: svo} = _attrs, :blown_save_percentage) do
    bs / svo
  end

  def calculate(%{save_opportunities: 0} = _attrs, :save_percentage), do: 0.0

  def calculate(%{saves: s, save_opportunities: svo} = _attrs, :save_percentage) do
    s / svo
  end

  def calculate(%{games_started: 0} = _attrs, :complete_game_percentage), do: 0.0

  def calculate(%{complete_games: cg, games_started: gs} = _attrs, :complete_game_percentage) do
    cg / gs
  end

  def calculate(%{outs_pitched: 0} = _attrs, :earned_run_average), do: 0.0

  def calculate(%{earned_runs: er, outs_pitched: outs} = _attrs, :earned_run_average) do
    er / outs * 27
  end

  def calculate(%{games: 0} = _attrs, :games_finished_percentage), do: 0.0

  def calculate(%{games_finished: gf, games: g} = _attrs, :games_finished_percentage) do
    gf / g
  end

  def calculate(%{ground_balls: gb, fly_balls: fb} = _attrs, :ground_ball_percentage) do
    balls_in_play = gb + fb

    if balls_in_play > 0 do
      gb / (gb + fb)
    else
      0.0
    end
  end

  def calculate(%{outs_pitched: 0} = _attrs, :hits_per_9), do: 0.0

  def calculate(%{hits: h, outs_pitched: outs} = _attrs, :hits_per_9) do
    h / outs * 27
  end

  def calculate(%{outs_pitched: 0} = _attrs, :home_runs_per_9), do: 0.0

  def calculate(%{home_runs: hr, outs_pitched: outs} = _attrs, :home_runs_per_9) do
    hr / outs * 27
  end

  def calculate(%{games: 0} = _attrs, :pitches_per_game), do: 0.0

  def calculate(%{pitches_thrown: pi, games: g} = _attrs, :pitches_per_game) do
    pi / g
  end

  def calculate(%{games_started: 0} = _attrs, :quality_start_percentage), do: 0.0

  def calculate(%{quality_starts: qs, games_started: gs} = _attrs, :quality_start_percentage) do
    qs / gs
  end

  def calculate(%{games_started: 0} = _attrs, :run_support_per_start), do: 0.0

  def calculate(%{run_support: rs, games_started: gs} = _attrs, :run_support_per_start) do
    rs / gs
  end

  def calculate(%{outs_pitched: 0} = _attrs, :runs_per_9), do: 0.0

  def calculate(%{runs: r, outs_pitched: outs} = _attrs, :runs_per_9) do
    r / outs * 27
  end

  def calculate(%{outs_pitched: 0} = _attrs, :strikeouts_per_9), do: 0.0

  def calculate(%{strikeouts: k, outs_pitched: outs} = _attrs, :strikeouts_per_9) do
    k / outs * 27
  end

  def calculate(%{walks: 0} = _attrs, :strikeouts_to_walks_ratio), do: 0.0

  def calculate(%{strikeouts: k, walks: bb} = _attrs, :strikeouts_to_walks_ratio) do
    k / bb
  end

  def calculate(%{outs_pitched: 0} = _attrs, :walks_per_9), do: 0.0

  def calculate(%{walks: bb, outs_pitched: outs} = _attrs, :walks_per_9) do
    bb / outs * 27
  end

  def calculate(%{outs_pitched: 0} = _attrs, :walks_hits_per_inning_pitched), do: 0.0

  def calculate(
        %{walks: bb, hits: h, outs_pitched: outs} = _attrs,
        :walks_hits_per_inning_pitched
      ) do
    (bb + h) / outs * 3
  end

  def calculate(%{games_started: 0} = _attrs, :winning_percentage), do: 0.0

  def calculate(%{wins: w, games_started: gs} = _attrs, :winning_percentage) do
    w / gs
  end

  def calculate(%{inherited_runners: 0} = _attrs, :inherited_runners_scored_percentage), do: 0.0

  def calculate(
        %{inherited_runners: ir, inherited_runners_scored: irs} = _attrs,
        :inherited_runners_scored_percentage
      ) do
    irs / ir
  end
end
