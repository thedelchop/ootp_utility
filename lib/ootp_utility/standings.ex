defmodule OOTPUtility.Standings do
  @moduledoc """
  The Standings context.
  """
  alias OOTPUtility.{Leagues, Repo, Standings, Teams}

  import Ecto.Query

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

  def for_league(
        %Leagues.League{conferences: [], divisions: %Ecto.Association.NotLoaded{}} = league
      ) do
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

  def for_conference(
        %Leagues.Conference{divisions: [], teams: %Ecto.Association.NotLoaded{}} = conference
      ) do
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
  @spec for_team(Teams.Team.t()) :: Standings.Team.t()
  def for_team(%Teams.Team{record: %Ecto.Association.NotLoaded{}} = team) do
    team
    |> Repo.preload(:record)
    |> for_team()
  end

  def for_team(%Teams.Team{} = team), do: Standings.Team.new(team)

  @doc """
  Returns a %Standings.Team{} associated with the specified %Teams.Team{}
  for its position in the %Leagues.Conference{} or %Leagues.Leauge{}

  ## Examples

      iex> for_team(%Teams.Team{}, %League.League{})
      %Standings.Team{}

      iex> for_team(%Teams.Team{}, %League.Conference{})
      %Standings.Team{}

  """
  @spec for_team(Teams.Team.t(), Leagues.League.t() | Leagues.Conference.t()) ::
          Standings.Team.t()
  def for_team(%Teams.Team{record: %Ecto.Association.NotLoaded{}} = team, league_or_conference) do
    team
    |> Repo.preload(:record)
    |> for_team(league_or_conference)
  end

  def for_team(%Teams.Team{id: team_id} = team, %Leagues.League{id: league_id} = _league) do
    order_by = [desc: :wins]
    partition = dynamic([tr, t], t.league_id)

    ranking_query =
      from tr in Standings.TeamRecord,
        join: t in Teams.Team,
        on: tr.team_id == t.id,
        where: t.league_id == ^league_id,
        select: %{
          position: rank() |> over(:rankings),
          most_wins: first_value(tr.wins) |> over(:rankings),
          id: tr.id
        },
        windows: [
          rankings: [partition_by: ^partition, order_by: ^order_by]
        ]

    query =
      from tr in Standings.TeamRecord,
        join: r in subquery(ranking_query),
        on: tr.id == r.id,
        select: %{tr | position: r.position, games_behind: (r.most_wins - tr.wins) / 1.0},
        where: tr.team_id == ^team_id

    league_record = Repo.one(query)

    do_for_team(%{team | record: league_record})
  end

  def for_team(
        %Teams.Team{id: team_id} = team,
        %Leagues.Conference{id: conference_id} = _conference
      ) do
    order_by = [desc: :wins]
    partition = dynamic([tr, t], t.conference_id)

    ranking_query =
      from tr in Standings.TeamRecord,
        join: t in Teams.Team,
        on: tr.team_id == t.id,
        where: t.conference_id == ^conference_id,
        select: %{
          position: rank() |> over(:rankings),
          most_wins: first_value(tr.wins) |> over(:rankings),
          id: tr.id
        },
        windows: [
          rankings: [partition_by: ^partition, order_by: ^order_by]
        ]

    query =
      from tr in Standings.TeamRecord,
        join: r in subquery(ranking_query),
        on: tr.id == r.id,
        select: %{tr | position: r.position, games_behind: (r.most_wins - tr.wins) / 1.0},
        where: tr.team_id == ^team_id

    conf_record = Repo.one(query)

    do_for_team(%{team | record: conf_record})
  end

  def do_for_team(%Teams.Team{} = team), do: Standings.Team.new(team)
end
