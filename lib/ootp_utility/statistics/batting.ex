defmodule OOTPUtility.Statistics.Batting do
  @moduledoc """
  The Statistics.Batting context.
  """

  import Ecto.Query, warn: false
  alias OOTPUtility.Repo

  alias OOTPUtility.Statistics.Batting.Team

  @doc """
  Returns the list of team_batting_stats.

  ## Examples

      iex> list_team_batting_stats()
      [%Team{}, ...]

  """
  def list_team_batting_stats do
    Repo.all(Team)
  end

  alias OOTPUtility.Statistics.Batting.Player

  @doc """
  Returns the list of player_career_batting_stats.

  ## Examples

      iex> list_player_career_batting_stats()
      [%Player{}, ...]

  """
  def list_player_career_batting_stats do
    Repo.all(Player)
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
