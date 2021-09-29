defmodule OOTPUtility.Statistics.Batting.PlayerSchema do
  alias OOTPUtility.Players

  import Ecto.Changeset, only: [change: 2]
  import OOTPUtility.Statistics.Batting.Calculations

  defmacro __using__(opts) do
    filename = Keyword.fetch!(opts, :from)
    composite_key = Keyword.get(opts, :composite_key, nil)
    foreign_key = Keyword.get(opts, :foreign_key, nil)

    quote do
      import String, only: [to_integer: 1]
      import OOTPUtility.Statistics.Batting.PlayerSchema

      use OOTPUtility.Statistics.Batting.Schema,
        from: unquote(filename),
        composite_key: unquote(composite_key),
        foreign_key: unquote(foreign_key)

      def update_batting_import_changeset(%Ecto.Changeset{} = changeset) do
        add_missing_statistics(changeset)
      end

      def sanitize_player_batting_attributes(attrs),
        do:
          OOTPUtility.Statistics.Batting.PlayerSchema.sanitize_player_batting_attributes(
            __MODULE__,
            attrs
          )

      def sanitize_batting_attributes(%{team_id: "0"} = attrs) do
        sanitize_batting_attributes(%{attrs | team_id: nil})
      end

      def sanitize_batting_attributes(%{league_id: league_id} = attrs) do
        league_id =
          if(to_integer(league_id) < 1) do
            nil
          else
            league_id
          end

        attrs
        |> Map.put(:league_id, league_id)
        |> __MODULE__.sanitize_player_batting_attributes()
      end

      defoverridable sanitize_player_batting_attributes: 1
    end
  end

  defmacro player_batting_schema(source, do: block) do
    quote do
      batting_schema unquote(source) do
        field :ubr, :float
        field :war, :float
        field :wpa, :float

        belongs_to :player, Players.Player

        unquote(block)
      end
    end
  end

  def sanitize_player_batting_attributes(_module, attrs), do: attrs

  def add_missing_statistics(%Ecto.Changeset{} = changeset) do
    changeset
    |> add_statistic(:singles)
    |> add_statistic(:extra_base_hits)
    |> add_statistic(:total_bases)
    |> add_statistic(:batting_average)
    |> add_statistic(:on_base_percentage)
    |> add_statistic(:slugging)
    |> add_statistic(:runs_created)
    |> add_statistic(:on_base_plus_slugging)
    |> add_statistic(:isolated_power)
    |> add_statistic(:stolen_base_percentage)
  end

  defp add_statistic(%Ecto.Changeset{changes: attrs} = changeset, stat_name) do
    value = calculate(attrs, stat_name)
    value = if is_float(value), do: Float.round(value, 4), else: value

    change(changeset, %{stat_name => value})
  end
end
