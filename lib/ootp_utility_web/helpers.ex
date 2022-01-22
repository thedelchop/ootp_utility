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

  @type suffix :: <<_::16>>

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

  def capitalize_all(atom) when is_atom(atom) do
    atom
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> capitalize_all()
  end

  def capitalize_all(string) do
    string
    |> String.split(" ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
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

  @doc """

    Here is the conversion of ability/potential ratings to stars

    | Stars | Min | Max |
    | ----- | --- | --- |
    | 5     | 78  | 80  |
    | 4.5   | 72  | 77  |
    | 4     | 65  | 71  |
    | 3.5   | 59  | 64  |
    | 3     | 51  | 58  |
    | 2.5   | 43  | 50  |
    | 2     | 35  | 42  |
    | 1.5   | 25  | 34  |
    | 1     | 21  | 24  |
    | 0.5   | 20  | 20  |
  """
  def player_rating_as_stars(rating) do
    cond do
      rating > 77 ->
        5.0

      rating > 71 ->
        4.5

      rating > 64 ->
        4.0

      rating > 58 ->
        3.5

      rating > 50 ->
        3.0

      rating > 42 ->
        2.5

      rating > 34 ->
        2.0

      rating > 24 ->
        1.5

      rating > 20 ->
        1.0

      true ->
        0.5
    end
  end

  @sm_min_width 640
  @md_min_width 768
  @lg_min_width 1024
  @xl_min_width 1280

  def display_size(viewport) do
    viewport
    |> Map.get("width", 768)
    |> do_display_size()
  end

  defp do_display_size(width) when width < @sm_min_width, do: :xsmall
  defp do_display_size(width) when width < @md_min_width, do: :small
  defp do_display_size(width) when width < @lg_min_width, do: :medium
  defp do_display_size(width) when width < @xl_min_width, do: :large
  defp do_display_size(_width), do: :xlarge
end
