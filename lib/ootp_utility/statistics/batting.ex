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
end
