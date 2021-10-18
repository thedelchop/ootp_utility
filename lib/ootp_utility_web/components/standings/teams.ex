defmodule OOTPUtilityWeb.Components.Standings.Teams do
  use Surface.Component

  alias OOTPUtilityWeb.Components.Shared.Table
  alias OOTPUtilityWeb.Components.Shared.Table.Column
  alias OOTPUtility.Standings
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  prop parent_path, :string, default: ""
  prop parent_name, :string, default: ""
  prop standings, :struct

  def header_class(_col, 0) do
    {
      "w-1/3",
      "px-3",
      "py-1",
      "lg:px-6",
      "lg:py-3",
      "text-left",
      "text-xs",
      "font-bold",
      "text-gray-900",
      "uppercase",
      "tracking-wider"
    }
  end

  def header_class(_col, _index) do
    Enum.join([
      "px-3",
      "py-1",
      "lg:px-6",
      "lg:py-3",
      "text-right",
      "text-xs",
      "font-medium",
      "text-gray-500",
      "uppercase",
      "tracking-wider"
    ], " ")
  end

  def column_class(_standing, 0) do
    Enum.join([
      "px-3", "py-2", "lg:px-6", "lg:py-4", "whitespace-nowrap"
    ], " ")
  end

  def column_class(_standing, 5) do
    Enum.join([
      "px-3",
      "py-2",
      "lg:px-6",
      "lg:py-4",
      "whitespace-nowrap",
      "text-sm",
      "text-gray-500",
      "text-right",
      "hidden",
      "lg:table-cell"
    ], " ")
  end

  def column_class(_standing, _index) do
    Enum.join([
      "px-3",
      "py-2",
      "lg:px-6",
      "lg:py-4",
      "whitespace-nowrap",
      "text-sm",
      "text-gray-500",
      "text-right"
    ], " ")
  end

  def id() do
    Integer.to_string(Enum.random(0..100000))
  end

  def winning_percentage(%Standings.Team{winning_percentage: pct} = _standing) do
    pct
    |> :erlang.float_to_binary(decimals: 3)
    |> String.trim_leading("0")
  end

  def streak(%Standings.Team{streak: streak} = _standing) when streak > 0, do: "W#{streak}"

  def streak(%Standings.Team{streak: streak} = _standing), do: "L#{abs(streak)}"
end
