defmodule OOTPUtility.PlayersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OOTPUtility.Players` context.
  """
  import Ecto.Changeset
  import OOTPUtility.TeamsFixtures
  import OOTPUtility.Fixtures.Utilities

  alias OOTPUtility.Repo
  alias OOTPUtility.Players.Player
  alias OOTPUtility.Teams.Team

  @doc """
  Generate a player.
  """

  def player_fixture(attrs \\ %{}, team \\ nil)

  def player_fixture(attrs, nil), do: player_fixture(attrs, team_fixture())

  def player_fixture(attrs, %Team{league_id: league_id, id: id}) do
    {:ok, player} =
      attrs
      |> Enum.into(%{
        id: generate_id(),
        age: 42,
        bats: 42,
        date_of_birth: "some date_of_birth",
        experience: 42,
        first_name: "some first_name",
        free_agent: true,
        height: 42,
        last_name: "some last_name",
        league_id: league_id,
        local_popularity: 42,
        national_popularity: 42,
        nickname: "some nickname",
        organization_id: id,
        position: 42,
        retired: true,
        role: 42,
        team_id: id,
        throws: 42,
        uniform_number: 42,
        weight: 42
      })
      |> create_player()

    player
  end

  defp create_player(attrs) do
    %Player{}
    |> cast(attrs, [
      :id,
      :team_id,
      :league_id,
      :organization_id,
      :first_name,
      :last_name,
      :nickname,
      :weight,
      :height,
      :age,
      :date_of_birth,
      :experience,
      :uniform_number,
      :bats,
      :throws,
      :position,
      :role,
      :free_agent,
      :retired,
      :local_popularity,
      :national_popularity
    ])
    |> validate_required([
      :id,
      :team_id,
      :league_id,
      :organization_id,
      :first_name,
      :last_name,
      :nickname,
      :weight,
      :height,
      :age,
      :date_of_birth,
      :experience,
      :uniform_number,
      :bats,
      :throws,
      :position,
      :role,
      :free_agent,
      :retired,
      :local_popularity,
      :national_popularity
    ])
    |> foreign_key_constraint(:league_id)
    |> foreign_key_constraint(:team_id)
    |> Repo.insert()
  end
end
