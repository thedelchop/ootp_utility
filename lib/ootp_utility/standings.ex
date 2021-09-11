defmodule OOTPUtility.Standings do
  @moduledoc """
  The Standings context.
  """

  alias OOTPUtility.Repo

  alias OOTPUtility.Standings.TeamRecord

  @doc """
  Returns the list of team_records.

  ## Examples

      iex> list_team_records()
      [%TeamRecord{}, ...]

  """
  def list_team_records do
    Repo.all(TeamRecord)
  end

  @doc """
  Gets a single team_record.

  Raises `Ecto.NoResultsError` if the Team record does not exist.

  ## Examples

      iex> get_team_record!(123)
      %TeamRecord{}

      iex> get_team_record!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team_record!(id), do: Repo.get!(TeamRecord, id)
end
