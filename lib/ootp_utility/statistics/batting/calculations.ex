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
end
