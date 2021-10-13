defmodule OOTPUtility.Standings do
  @moduledoc """
  The Standings context.
  """
  alias OOTPUtility.Repo

  alias OOTPUtility.Standings
  alias OOTPUtility.Leagues.{Conference, Division, League}

  @doc """
  Returns the list of team_records.

  ## Examples

      iex> list_team_records()
      [%TeamRecord{}, ...]

  """
  @spec for_league(League.t()) :: Standings.League.t()
  def for_league(league) do
    Standings.League.new(league)
  end

  @spec for_conference(Conference.t()) :: Standings.Conference.t()
  def for_conference(conference) do
    Standings.Conference.new(conference)
  end

  @spec for_division(Division.t()) :: Standings.Division.t()
  def for_division(division) do
    Standings.Division.new(division)
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
  def get_team_record!(id), do: Repo.get!(Standings.TeamRecord, id)
end
