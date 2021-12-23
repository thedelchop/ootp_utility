defmodule OOTPUtility.Standings do
  @moduledoc """
  The Standings context.
  """
  alias OOTPUtility.Repo

  alias OOTPUtility.{Standings, Teams}
  alias OOTPUtility.Leagues.{Conference, Division, League}

  import Ecto.Query, only: [where: 3]

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

  @spec for_team(Teams.Team.t()) :: Standings.TeamRecord.t()
  def for_team(%Teams.Team{id: id, record: %Ecto.Association.NotLoaded{}} = _team) do
    Standings.TeamRecord
    |> where([tr], tr.team_id == ^id)
    |> Repo.one!()
  end
  def for_team(%Teams.Team{record: team_record} = _team), do: team_record

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
