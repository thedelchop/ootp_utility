defmodule OOTPUtility.LeaguesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OOTPUtility.Leagues` context.
  """
  import Ecto.Changeset
  import OOTPUtility.Fixtures.Utilities

  alias OOTPUtility.Repo
  alias OOTPUtility.Leagues.{Conference, Division, League}

  @doc """
  Generate a league.
  """
  def league_fixture(attrs \\ %{}) do
    id = generate_id()
    name = Map.get(attrs, :name, "My League")
    slug = Slug.slugify("#{name}-#{id}")

    {:ok, league} =
      attrs
      |> Map.put(:id, id)
      |> Map.put(:name, name)
      |> Map.put(:slug, slug)
      |> Enum.into(%{
        abbr: "some abbr",
        current_date: ~D[2021-09-05],
        league_level: "some league_level",
        logo_filename: "some logo_filename",
        season_year: 42,
        start_date: ~D[2021-09-05]
      })
      |> create_league()

    league
  end

  @doc """
  Generate a conference.
  """
  def conference_fixture(attrs \\ %{}, league \\ nil)

  def conference_fixture(attrs, nil) do
    conference_fixture(attrs, league_fixture())
  end

  def conference_fixture(attrs, league) do
    id = generate_id()
    name = Map.get(attrs, :name, "My Conference")
    slug = Slug.slugify("#{name}-#{id}")

    {:ok, conference} =
      attrs
      |> Map.put(:id, id)
      |> Map.put(:name, name)
      |> Map.put(:slug, slug)
      |> Enum.into(%{
        abbr: "some abbr",
        designated_hitter: true,
        league_id: league.id
      })
      |> create_conference()

    conference
  end

  @doc """
  Generate a division.
  """
  def division_fixture(attrs \\ %{}, league_or_conference \\ nil)

  def division_fixture(attrs, nil) do
    division_fixture(attrs, conference_fixture())
  end

  def division_fixture(attrs, %League{} = league) do
    division_fixture(attrs, conference_fixture(league))
  end

  def division_fixture(attrs, conference) do
    id = generate_id()
    name = Map.get(attrs, :name, "My Division")
    slug = Slug.slugify("#{name}-#{id}")

    {:ok, division} =
      attrs
      |> Map.put(:id, id)
      |> Map.put(:name, name)
      |> Map.put(:slug, slug)
      |> Enum.into(%{
        id: "#{conference.id}-#{id}",
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
      :slug,
      :current_date,
      :league_level,
      :logo_filename,
      :name,
      :season_year,
      :start_date
    ])
    |> validate_required([
      :id,
      :slug,
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
    |> cast(attrs, [:id, :abbr, :name, :slug, :designated_hitter, :league_id])
    |> validate_required([:id, :abbr, :name, :designated_hitter, :league_id])
    |> foreign_key_constraint(:league_id)
    |> Repo.insert()
  end

  defp create_division(attrs) do
    %Division{}
    |> cast(attrs, [:id, :name, :league_id, :slug, :conference_id])
    |> validate_required([:id, :name, :league_id, :conference_id])
    |> foreign_key_constraint(:league_id)
    |> foreign_key_constraint(:conference_id)
    |> Repo.insert()
  end
end
