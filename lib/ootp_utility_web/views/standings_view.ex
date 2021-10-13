defmodule OOTPUtilityWeb.StandingsView do
  use OOTPUtilityWeb, :view

  alias OOTPUtility.Standings.{Conference, Division, League, Team}
  alias __MODULE__

  def winning_percentage(%Team{winning_percentage: pct} = _standing) do
    pct
    |> :erlang.float_to_binary(decimals: 3)
    |> String.trim_leading("0")
  end

  def streak(%Team{streak: streak} = _standing) when streak > 0, do: "W#{streak}"

  def streak(%Team{streak: streak} = _standing), do: "L#{abs(streak)}"

  def child_standings(
        %League{conference_standings: [], division_standings: standings} = _standing,
        conn
      ) do
    standings
    |> Enum.map(&render(StandingsView, "division.html", conn: conn, standings: &1))
    |> Enum.map(&Phoenix.HTML.Safe.to_iodata/1)
    |> raw()
  end

  def child_standings(
        %League{conference_standings: standings} = _standing,
        conn
      ) do
    standings
    |> Enum.map(&render(StandingsView, "conference.html", conn: conn, standings: &1))
    |> Enum.map(&Phoenix.HTML.Safe.to_iodata/1)
    |> raw()
  end
end
