defmodule OOTPUtilityWeb.StandingsView do
  use OOTPUtilityWeb, :view

  alias OOTPUtility.Standings.Team

  def winning_percentage(%Team{winning_percentage: pct} = _standing) do
    pct
    |> :erlang.float_to_binary(decimals: 3)
    |> String.trim_leading("0")
  end

  def streak(%Team{streak: streak} = _standing) when streak > 0, do: "W#{streak}"

  def streak(%Team{streak: streak} = _standing), do: "L#{abs(streak)}"
end
