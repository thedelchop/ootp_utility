defmodule OOTPUtility.LeaguesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OOTPUtility.Leagues` context.
  """

  @doc """
  Generate a league.
  """
  def league_fixture(attrs \\ %{}) do
    {:ok, league} =
      attrs
      |> Enum.into(%{
        abbr: "some abbr",
        current_date: ~D[2021-09-05],
        league_level: "some league_level",
        logo_filename: "some logo_filename",
        name: "some name",
        season_year: 42,
        start_date: ~D[2021-09-05]
      })
      |> OOTPUtility.Leagues.create_league()

    league
  end
end
