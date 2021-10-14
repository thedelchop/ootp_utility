defmodule OOTPUtilityWeb.Standings.TeamView do
  use OOTPUtilityWeb.StandingsView

  alias OOTPUtility.Standings

  def winning_percentage(%Standings.Team{winning_percentage: pct} = _standing) do
    pct
    |> :erlang.float_to_binary(decimals: 3)
    |> String.trim_leading("0")
  end

  def streak(%Standings.Team{streak: streak} = _standing) when streak > 0, do: "W#{streak}"

  def streak(%Standings.Team{streak: streak} = _standing), do: "L#{abs(streak)}"
end
