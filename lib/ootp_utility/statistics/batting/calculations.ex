defmodule OOTPUtility.Statistics.Batting.Calculations do
  alias OOTPUtility.Statistics

  def calculate(%{stolen_bases: 0, caught_stealing: 0} = _attrs, :stolen_base_percentage), do: 0.0

  def calculate(%{stolen_bases: sb, caught_stealing: cs} = _attrs, :stolen_base_percentage) do
    sb / (sb + cs)
  end

  def calculate(%{at_bats: 0}, :isolated_power), do: 0.0

  def calculate(%{at_bats: ab} = attrs, :isolated_power) do
    tb = Statistics.Calculations.calculate(attrs, :total_bases)
    singles = calculate(attrs, :singles)

    (tb - singles) / ab
  end

  def calculate(
        %{
          doubles: d,
          triples: t,
          home_runs: hr
        },
        :extra_base_hits
      ) do
    d + t + hr
  end

  def calculate(
        %{
          hits: h
        } = attrs,
        :singles
      ) do
    h - calculate(attrs, :extra_base_hits)
  end

  def calculate(
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
    tb = Statistics.Calculations.calculate(attrs, :total_bases)
    times_on_base = h + bb + hbp - cs - gdp
    bases_advanced = tb + 0.26 * (bb + hbp + -ibb) + 0.52 * (sh + sf + sb)
    opportunities = ab + bb + hbp + sh + sf

    if opportunities == 0, do: 0.0, else: times_on_base * bases_advanced / opportunities
  end

  def calculate(attrs, :plate_appearances) do
    attrs
    |> Map.take([
      :at_bats,
      :intentional_walks,
      :catchers_interference,
      :hit_by_pitch,
      :sacrifices,
      :sacrifice_flys,
      :walk
    ])
    |> Enum.reduce(0, fn {_k, v}, acc -> acc + v end)
  end

  def calculate(
        %{
          singles: singles,
          doubles: doubles,
          triples: triples,
          home_runs: home_runs
        },
        :hits
      ) do
    singles + doubles + triples + home_runs
  end

  def calculate(
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

  def calculate(%{at_bats: 0}, :batting_average), do: 0.0

  def calculate(%{hits: h, at_bats: ab}, :batting_average) do
    h / ab
  end

  def calculate(
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

  def calculate(%{at_bats: 0}, :slugging), do: 0.0

  def calculate(
        %{
          at_bats: ab
        } = attrs,
        :slugging
      ) do
    total_bases = calculate(attrs, :total_bases)
    total_bases / ab
  end

  def calculate(
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

  def calculate(attrs, :on_base_plus_slugging) do
    calculate(attrs, :on_base_percentage) + calculate(attrs, :slugging)
  end
end
