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

  @type suffix :: <<_::2>>

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

  @spec ordinalize(integer()) :: String.t()
  def ordinalize(number) when is_integer(number) and number >= 0 do
    [to_string(number), suffix(number)]
    |> IO.iodata_to_binary()
  end

  def ordinalize(number), do: number

  @spec suffix(integer()) :: suffix()
  def suffix(num) when is_integer(num) and num > 100,
    do: num |> rem(100) |> suffix()

  def suffix(num) when num in 11..13, do: "th"
  def suffix(num) when num > 10, do: num |> rem(10) |> suffix()
  def suffix(1), do: "st"
  def suffix(2), do: "nd"
  def suffix(3), do: "rd"
  def suffix(_), do: "th"
end
