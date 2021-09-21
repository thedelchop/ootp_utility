defmodule OOTPUtility.Players do
  @moduledoc """
  The Players context.
  """

  import Ecto.Query, warn: false
  alias OOTPUtility.Repo

  alias OOTPUtility.Players.Player
  alias OOTPUtility.Teams.Team

  @doc """
  Returns all players assoicated with a specified team

  ## Examples

      iex> for_team(%Team{})
      [%Player{}, ...]

  """
  def for_team(%Team{id: team_id}) do
    Player
    |> where([p], p.team_id == ^team_id)
    |> Repo.all()
  end

  @doc """
  Returns all players assoicated with a specified parent team, aka an organization

  ## Examples

      iex> for_organization(%Team{})
      [%Player{}, ...]

  """
  def for_organization(%Team{id: organization_id}) do
    Player
    |> where([p], p.organization_id == ^organization_id)
    |> Repo.all()
  end

  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(id), do: Repo.get!(Player, id)
end
