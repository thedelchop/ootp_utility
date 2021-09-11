defmodule OOTPUtility.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OOTPUtility.Teams` context.
  """

  import Ecto.Changeset

  alias OOTPUtility.Repo
  alias OOTPUtility.Teams.Team

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}, division) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        id: "1",
        abbr: "MYT",
        level: "MLB",
        logo_filename: "my_team.png",
        name: "My Team",
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
