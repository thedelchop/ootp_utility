defmodule OOTPUtility.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OOTPUtility.Teams` context.
  """

  import Ecto.Changeset
  import OOTPUtility.LeaguesFixtures
  import OOTPUtility.Fixtures.Utilities

  alias OOTPUtility.{Leagues, Repo}
  alias OOTPUtility.Teams.Team

  @doc """
  Generate a team.
  """

  def team_fixture(attrs \\ %{}, parent \\ nil)

  def team_fixture(attrs, nil) do
    team_fixture(attrs, league_fixture())
  end

  def team_fixture(attrs, %Leagues.League{} = league) do
    team_fixture(attrs, conference_fixture(%{}, league))
  end

  def team_fixture(attrs, %Leagues.Conference{} = conference) do
    team_fixture(attrs, division_fixture(%{}, conference))
  end

  def team_fixture(attrs, %Leagues.Division{} = division) do
    id = generate_id()
    name = Map.get(attrs, :name, "My Team")
    slug = Slug.slugify("#{name}-#{id}")

    {:ok, team} =
      attrs
      |> Map.put(:id, id)
      |> Map.put(:name, name)
      |> Map.put(:slug, slug)
      |> Enum.into(%{
        abbr: "MYT",
        level: "MLB",
        logo_filename: "my_team.png",
        league_id: division.league_id,
        conference_id: division.conference_id,
        division_id: division.id
      })
      |> create_team()

    team
  end

  @doc false
  defp create_team(attrs) do
    %Team{}
    |> cast(attrs, [
      :id,
      :name,
      :abbr,
      :level,
      :slug,
      :logo_filename,
      :league_id,
      :conference_id,
      :division_id
    ])
    |> validate_required([
      :id,
      :name,
      :abbr,
      :level,
      :slug,
      :logo_filename,
      :league_id,
      :conference_id,
      :division_id
    ])
    |> foreign_key_constraint(:league_id)
    |> foreign_key_constraint(:conference_id)
    |> foreign_key_constraint(:division_id)
    |> Repo.insert()
  end
end
