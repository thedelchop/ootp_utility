defmodule OOTPUtility.Standings do
  @moduledoc """
  The Standings context.
  """
  alias OOTPUtility.{Leagues, Repo, Standings, Teams}

  import Ecto.Query, only: [where: 3]

  @doc """
  Returns a %Standings.League{} associated with the specified %Leagues.League{}

  ## Examples

      iex> for_league(%Leagues.League{})
      %Standings.League{}

  """
  @spec for_league(Leagues.League.t()) :: Standings.League.t()

  def for_league(%Leagues.League{conferences: %Ecto.Association.NotLoaded{}} = league) do
    league
    |> Repo.preload(:conferences)
    |> for_league()
  end

  def for_league(%Leagues.League{conferences: [], divisions: %Ecto.Association.NotLoaded{}} = league) do
    league
    |> Repo.preload(divisions: [:league, :conference, teams: [:record]])
    |> for_league()
  end

  def for_league(league) do
    Standings.League.new(league)
  end

  @doc """
  Returns a %Standings.Conference{} associated with the specified %Leagues.Conference{}

  ## Examples

      iex> for_conference(%Leagues.Conference{})
      %Standings.Conference{}

  """
  @spec for_conference(Leagues.Conference.t()) :: Standings.Conference.t()
  def for_conference(%Leagues.Conference{divisions: %Ecto.Association.NotLoaded{}} = conference) do
    conference
    |> Repo.preload(divisions: [:league, :conference, teams: [:record]])
    |> for_conference()
  end

  def for_conference(%Leagues.Conference{divisions: [], teams: %Ecto.Association.NotLoaded{}} = conference) do
    conference
    |> Repo.preload(teams: [:record])
    |> for_conference()
  end

  def for_conference(conference) do
    Standings.Conference.new(conference)
  end

  @doc """
  Returns a %Standings.Division{} associated with the specified %Leagues.Division{}

  ## Examples

      iex> for_division(%Leagues.Division{})
      %Standings.Division{}

  """
  @spec for_division(Leagues.Division.t()) :: Standings.Division.t()
  def for_division(
        %Leagues.Division{
          teams: %Ecto.Association.NotLoaded{}
        } = division
      ) do
    division
    |> Repo.preload([:conference, teams: [:record]])
    |> for_division()
  end

  def for_division(division) do
    Standings.Division.new(division)
  end

  @doc """
  Returns a %Standings.Team{} associated with the specified %Teams.Team{}

  ## Examples

      iex> for_team(%Teams.Team{})
      %Standings.Team{}

  """
  @spec for_team(Teams.Team.t()) :: Standings.TeamRecord.t()
  def for_team(%Teams.Team{id: id, record: %Ecto.Association.NotLoaded{}} = _team) do
    Standings.TeamRecord
    |> where([tr], tr.team_id == ^id)
    |> Repo.one!()
  end

  def for_team(%Teams.Team{record: team_record} = _team), do: team_record
end
