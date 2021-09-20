defmodule OOTPUtility.Statistics.Fielding do
  @moduledoc """
  The Statistics.Fielding context.
  """

  import Ecto.Query, warn: false
  alias OOTPUtility.Repo

  alias OOTPUtility.Statistics.Fielding.Team

  @doc """
  Returns the list of team_fielding_stats.

  ## Examples

      iex> list_team_fielding_stats()
      [%Team{}, ...]

  """
  def list_team_fielding_stats do
    Repo.all(Team)
  end
end
