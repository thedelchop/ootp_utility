defmodule OOTPUtility.Imports.Helpers do
  def convert_league_level(league_level) do
    %{
      "1" => :major,
      "2" => :triple_a,
      "3" => :double_a,
      "4" => :single_a,
      "5" => :low_a,
      "6" => :rookie,
      "8" => :international,
      "10" => :college,
      "11" => :high_school
    }
    |> Map.get(league_level)
  end
end
