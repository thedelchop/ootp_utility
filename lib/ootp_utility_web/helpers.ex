defmodule OOTPUtilityWeb.Helpers do
  @stat_abbreviations %{
    batting_average: "avg",
    runs: "r",
    home_runs: "hr",
    runs_batted_in: "rbi",
    stolen_bases: "sb",
    wins: "w",
    saves: "s",
    strikeouts: "k",
    earned_run_average: "era",
    whip: "whip"
  }

  def friendly_date(date) do
    Timex.format!(date, "{0M}/{D}/{YYYY}")
  end

  def statistic_abbreviation(stat_name) when is_binary(stat_name) do
    stat_name
    |> String.to_atom()
    |> statistic_abbreviation()
  end

  def statistic_abbreviation(stat_name) do
    Map.fetch(@stat_abbreviations, stat_name)
  end
end
