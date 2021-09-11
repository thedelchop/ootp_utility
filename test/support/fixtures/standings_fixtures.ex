defmodule OOTPUtility.StandingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OOTPUtility.Standings` context.
  """
  import Ecto.Changeset
  alias OOTPUtility.Repo
  alias OOTPUtility.Standings.TeamRecord

  @doc """
  Generate a team_record.
  """
  def team_record_fixture(attrs \\ %{}, team) do
    {:ok, team_record} =
      attrs
      |> Enum.into(%{
        id: "1",
        games: 42,
        games_behind: 120.5,
        losses: 42,
        magic_number: 42,
        position: 42,
        streak: 42,
        winning_percentage: 120.5,
        wins: 42,
        team_id: team.id
      })
      |> create_team_record()

    team_record
  end

  defp create_team_record(attrs) do
    %TeamRecord{}
    |> cast(attrs, [:id, :games, :wins, :losses, :position, :winning_percentage, :games_behind, :streak, :magic_number, :team_id])
    |> validate_required([:id, :games, :wins, :losses, :position, :winning_percentage, :games_behind, :streak, :magic_number, :team_id])
    |> foreign_key_constraint(:team_id)
    |> Repo.insert()
  end
end
