defmodule OOTPUtility.Statistics.Pitching.Player.Schema do
  alias OOTPUtility.Utilities

  import OOTPUtility.Statistics.Pitching.Calculations
  import Ecto.Changeset, only: [change: 2]
  alias OOTPUtility.Players

  defmacro __using__(opts) do
    filename = Keyword.fetch!(opts, :from)
    composite_key = Keyword.get(opts, :composite_key, nil)
    foreign_key = Keyword.get(opts, :foreign_key, nil)

    quote do
      import OOTPUtility.Statistics.Pitching.Player.Schema

      use OOTPUtility.Statistics.Pitching.Schema,
        from: unquote(filename),
        composite_key: unquote(composite_key),
        foreign_key: unquote(foreign_key)

      def update_pitching_import_changeset(%Ecto.Changeset{} = changeset) do
        add_missing_statistics(changeset)
      end

      def sanitize_player_pitching_attributes(attrs),
        do:
          OOTPUtility.Statistics.Pitching.Player.Schema.sanitize_player_pitching_attributes(
            __MODULE__,
            attrs
          )

      def sanitize_pitching_attributes(%{team_id: "0"} = attrs) do
        sanitize_pitching_attributes(%{attrs | team_id: nil})
      end

      def sanitize_pitching_attributes(%{league_id: league_id} = attrs) do
        league_id =
          if(String.to_integer(league_id) < 1) do
            nil
          else
            league_id
          end

        attrs
        |> Map.put(:league_id, league_id)
        |> OOTPUtility.Statistics.Pitching.Player.Schema.rename_keys()
        |> __MODULE__.sanitize_player_pitching_attributes()
      end

      defoverridable sanitize_player_pitching_attributes: 1
    end
  end

  defmacro player_pitching_schema(source, do: block) do
    quote do
      pitching_schema unquote(source) do
        field :inherited_runners, :integer
        field :inherited_runners_scored, :integer
        field :inherited_runners_scored_percentage, :float
        field :leverage_index, :float
        field :win_probabilty_added, :float
        field :wins_above_replacement, :float

        belongs_to :player, Players.Player

        unquote(block)
      end
    end
  end

  def sanitize_player_pitching_attributes(_module, attrs), do: attrs

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
    value = calculate(attrs, stat_name)
    value = if is_float(value), do: Float.round(value, 4), else: value

    change(changeset, %{stat_name => value})
  end

  def rename_keys(attrs),
    do:
      Utilities.rename_keys(attrs, [
        {:ir, :inherited_runners},
        {:irs, :inherited_runners_scored},
        {:li, :leverage_index},
        {:war, :wins_above_replacement},
        {:wpa, :win_probability_added},
        {:outs, :outs_pitched}
      ])
end
