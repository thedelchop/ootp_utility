defmodule OOTPUtility.LeaguesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OOTPUtility.Leagues` context.
  """
  import Ecto.Changeset

  alias OOTPUtility.Repo
  alias OOTPUtility.Leagues.{Conference, Division, League}

  @doc """
  Generate a league.
  """
  def league_fixture(attrs \\ %{}) do
    {:ok, league} =
      attrs
      |> Enum.into(%{
        id: "1",
        abbr: "some abbr",
        current_date: ~D[2021-09-05],
        league_level: "some league_level",
        logo_filename: "some logo_filename",
        name: "My league",
        season_year: 42,
        start_date: ~D[2021-09-05]
      })
      |> create_league()

    league
  end

  @doc """
  Generate a conference.
  """
  def conference_fixture(attrs \\ %{}, league) do
    {:ok, conference} =
      attrs
      |> Enum.into(%{
        id: "1",
        abbr: "some abbr",
        designated_hitter: true,
        name: "My Conference",
        league_id: league.id
      })
      |> create_conference()

    conference
  end

  @doc """
  Generate a division.
  """
  def division_fixture(attrs \\ %{}, conference) do
    {:ok, division} =
      attrs
      |> Enum.into(%{
        id: "1",
        name: "My Division",
        conference_id: conference.id,
        league_id: conference.league_id
      })
      |> create_division()

    division
  end

  defp create_league(attrs) do
    %League{}
    |> cast(attrs, [
      :id,
      :abbr,
      :current_date,
      :league_level,
      :logo_filename,
      :name,
      :season_year,
      :start_date
    ])
    |> validate_required([
      :id,
      :abbr,
      :current_date,
      :league_level,
      :logo_filename,
      :name,
      :season_year,
      :start_date
    ])
    |> Repo.insert()
  end

  defp create_conference(attrs) do
    %Conference{}
    |> cast(attrs, [:id, :abbr, :name, :designated_hitter, :league_id])
    |> validate_required([:id, :abbr, :name, :designated_hitter, :league_id])
    |> foreign_key_constraint(:league_id)
    |> Repo.insert()
  end

  defp create_division(attrs) do
    %Division{}
    |> cast(attrs, [:id, :name, :league_id, :conference_id])
    |> validate_required([:id, :name, :league_id, :conference_id])
    |> foreign_key_constraint(:league_id)
    |> foreign_key_constraint(:conference_id)
    |> Repo.insert()
  end
end
