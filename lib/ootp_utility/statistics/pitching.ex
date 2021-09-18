defmodule OOTPUtility.Statistics.Pitching do
  @moduledoc """
  The Statistics.Pitching context.
  """

  import Ecto.Query, warn: false
  alias OOTPUtility.Repo

  alias OOTPUtility.Statistics.Pitching.Team

  @doc """
  Returns the list of team_pitching_stats.

  ## Examples

      iex> list_team_pitching_stats()
      [%Team{}, ...]

  """
  def list_team_pitching_stats do
    Repo.all(Team)
  end
end
