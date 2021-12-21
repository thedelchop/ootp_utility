defmodule OOTPUtility.Leagues.Level do
  defstruct [:id, :name, :abbr]

  alias __MODULE__

  @type t() :: %Level{
    id: atom(),
    name: binary(),
    abbr: binary()
  }

  @spec new(atom()) :: Level.t()
  def new(id) do
    %Level{
      id: id,
      name: build_name(id),
      abbr: get_abbreviation(id)
    }
  end

  defp build_name(:major), do: "Major League"

  defp build_name(id) do
    id
    |> Phoenix.Naming.humanize()
    |> String.split(" ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end


  defp get_abbreviation(id) do
    Map.fetch!(%{
      major: "ML",
      triple_a: "AAA",
      double_a: "AA",
      single_a: "A",
      low_a: "A-",
      rookie: "R",
      international: "INT",
      college: "COL",
      high_school: "HS"
    }, id)
  end
end
