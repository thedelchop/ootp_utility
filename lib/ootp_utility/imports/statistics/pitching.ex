defmodule OOTPUtility.Imports.Statistics.Pitching do
  import OOTPUtility.Imports.Statistics.Pitching.Calculations

  defmacro __using__(opts) do
    header_renames = Keyword.get(opts, :headers, [])
    filename = Keyword.get(opts, :from)
    schema = Keyword.get(opts, :schema)

    shared_renames = [
      {:ab, :at_bats},
      {:bb, :walks},
      {:bf, :plate_appearances},
      {:bk, :balks},
      {:bs, :blown_saves},
      {:cg, :complete_games},
      {:ci, :catchers_interference},
      {:cs, :caught_stealing},
      {:da, :doubles},
      {:dp, :double_plays},
      {:er, :earned_runs},
      {:fb, :fly_balls},
      {:g, :games},
      {:gb, :ground_balls},
      {:gf, :games_finished},
      {:gs, :games_started},
      {:ha, :hits},
      {:hld, :holds},
      {:hp, :hit_by_pitch},
      {:hra, :home_runs},
      {:iw, :intentional_walks},
      {:k, :strikeouts},
      {:l, :losses},
      {:pi, :pitches_thrown},
      {:qs, :quality_starts},
      {:r, :runs},
      {:ra, :relief_appearances},
      {:rs, :run_support},
      {:s, :saves},
      {:sa, :singles},
      {:sb, :stolen_bases},
      {:sf, :sacrifice_flys},
      {:sh, :sacrifices},
      {:sho, :shutouts},
      {:svo, :save_opportunities},
      {:ta, :triples},
      {:tb, :total_bases},
      {:w, :wins},
      {:wp, :wild_pitches}
    ]

    headers =
      shared_renames
      |> Keyword.merge(header_renames)

    quote do
      use OOTPUtility.Imports,
        from: unquote(filename),
        headers: unquote(headers),
        schema: unquote(schema)
    end
  end

  def add_missing_statistics(%Ecto.Changeset{} = changeset) do
    changeset
    |> add_statistic(:batting_average)
    |> add_statistic(:batting_average_on_balls_in_play)
    |> add_statistic(:blown_save_percentage)
    |> add_statistic(:complete_game_percentage)
    |> add_statistic(:earned_run_average)
    |> add_statistic(:games_finished_percentage)
    |> add_statistic(:ground_ball_percentage)
    |> add_statistic(:hits_per_9)
    |> add_statistic(:on_base_percentage)
    |> add_statistic(:on_base_plus_slugging)
    |> add_statistic(:pitches_per_game)
    |> add_statistic(:quality_start_percentage)
    |> add_statistic(:run_support_per_start)
    |> add_statistic(:runs_per_9)
    |> add_statistic(:save_percentage)
    |> add_statistic(:slugging)
    |> add_statistic(:strikeouts_per_9)
    |> add_statistic(:strikeouts_to_walks_ratio)
    |> add_statistic(:walks_per_9)
    |> add_statistic(:walks_hits_per_inning_pitched)
    |> add_statistic(:winning_percentage)
    |> add_statistic(:inherited_runners_scored_percentage)
  end

  defp add_statistic(%Ecto.Changeset{changes: attrs} = changeset, stat_name) do
    value =
      attrs
      |> calculate(stat_name)
      |> round(stat_name)

    Ecto.Changeset.change(changeset, %{stat_name => value})
  end

  @one_digit_precision [
    :pitches_per_game,
    :hits_per_9,
    :run_support_per_start,
    :runs_per_9,
    :strikeouts_per_9,
    :walks_per_9,
    :inherited_runners_scored_percentage
  ]

  @two_digit_precision [
    :earned_run_average,
    :walks_hits_per_inning_pitched,
    :save_percentage,
    :blown_save_percentage,
    :games_finished_percentage,
    :ground_ball_percentage,
    :quality_start_percentage,
    :winning_percentage
  ]

  @three_digit_precision [
    :batting_average,
    :batting_average_on_balls_in_play,
    :on_base_percentage,
    :on_base_plus_slugging,
    :slugging
  ]

  defp round(value, stat) when stat in @one_digit_precision do
    Float.round(value, 1)
  end

  defp round(value, stat) when stat in @two_digit_precision do
    Float.round(value, 2)
  end

  defp round(value, stat) when stat in @three_digit_precision do
    Float.round(value, 3)
  end

  defp round(value, _stat_name) do
    value
  end
end
