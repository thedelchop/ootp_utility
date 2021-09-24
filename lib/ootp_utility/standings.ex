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
    league
    |> Repo.preload(conferences: [divisions: [teams: [:record]]])
    |> Standings.League.new()
  end

  @spec for_conference(Conference.t()) :: Standings.Conference.t()
  def for_conference(conference) do
    conference
    |> Repo.preload(divisions: [teams: [:record]])
    |> Standings.Conference.new()
  end

  @spec for_division(Division.t()) :: Standings.Division.t()
  def for_division(division) do
    division
    |> Repo.preload(teams: [:record])
    |> Standings.Division.new()
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
