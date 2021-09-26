defmodule OOTPUtility.Statistics.Batting.PlayerSchema do
  alias OOTPUtility.Players

  import Ecto.Changeset, only: [change: 2]

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

  defp calculate(%{stolen_bases: 0, caught_stealing: 0} = _attrs, :stolen_base_percentage), do: 0.0

  defp calculate(%{stolen_bases: sb, caught_stealing: cs} = _attrs, :stolen_base_percentage) do
    sb / (sb + cs)
  end

  defp calculate(%{at_bats: 0}, :isolated_power), do: 0.0

  defp calculate(%{at_bats: ab} = attrs, :isolated_power) do
    tb = calculate(attrs, :total_bases)
    singles = calculate(attrs, :singles)

    (tb - singles) / ab
  end

  defp calculate(attrs, :on_base_plus_slugging) do
    calculate(attrs, :on_base_percentage) + calculate(attrs, :slugging)
  end

  defp calculate(%{at_bats: 0}, :slugging), do: 0.0

  defp calculate(
         %{
           at_bats: ab
         } = attrs,
         :slugging
       ) do
    total_bases = calculate(attrs, :total_bases)
    total_bases / ab
  end

  defp calculate(
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

  defp calculate(%{at_bats: 0}, :batting_average), do: 0.0

  defp calculate(%{hits: h, at_bats: ab}, :batting_average) do
    h / ab
  end

  defp calculate(
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

  defp calculate(
         %{
           doubles: d,
           triples: t,
           home_runs: hr
         },
         :extra_base_hits
       ) do
    d + t + hr
  end

  defp calculate(
         %{
           hits: h
         } = attrs,
         :singles
       ) do
    h - calculate(attrs, :extra_base_hits)
  end

  defp calculate(
         %{
           at_bats: ab,
           hits: h,
           walks: bb,
           hit_by_pitch: hbp,
           caught_stealing: cs,
           double_plays: gdp,
           intentional_walks: ibb,
           sacrifices: sh,
           sacrifice_flys: sf,
           stolen_bases: sb
         } = attrs,
         :runs_created
       ) do
    tb = calculate(attrs, :total_bases)
    times_on_base = h + bb + hbp - cs - gdp
    bases_advanced = tb + 0.26 * (bb + hbp + -ibb) + 0.52 * (sh + sf + sb)
    opportunities = ab + bb + hbp + sh + sf

    if opportunities == 0, do: 0.0, else: times_on_base * bases_advanced / opportunities
  end
end
