defmodule OOTPUtility.Games do
  @moduledoc """
  The Games context, includes functions that returns a Game or Games
  related to other resources in the application, like a Team.
  """

  import Ecto.Query, warn: false
  alias OOTPUtility.Repo

  alias OOTPUtility.Games.Game
  alias OOTPUtility.Teams.Team

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  @spec list_games() :: [Game.t()]
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Returns the list of games related to the specified Team.

  It accepts the following options:

    * `:limit` - The number of games returned by the query
    * `:start_date` - The earliest date for which to include games

  ## Examples

      iex> for_team(%Team{}, limit: 10)
      [%Game{}, ...]

      iex> for_team(%Team{}, start_date: ~D[2020-07-03])
      [%Game{}, ...]
  """
  @spec for_team(Team.t(), Keyword.t()) :: [Game.t()]
  def for_team(team, opts \\ Keyword.new())

  def for_team(%Team{id: _id, league: %Ecto.Association.NotLoaded{}} = team, opts) do
    team
    |> Repo.preload(:league)
    |> for_team(opts)
  end

  def for_team(%Team{} = team, opts) do
    do_for_team(team, opts)
  end

  def do_for_team(query \\ Game, team, opts)

  def do_for_team(query, %Team{id: id} = _team, []) do
    query
    |> where([g], g.away_team_id == ^id or g.home_team_id == ^id)
    |> preload([g], [
      :winning_pitcher,
      :losing_pitcher,
      :save_pitcher,
      away_team: [:record],
      home_team: [:record]
    ])
    |> Repo.all()
  end

  def do_for_team(query, %Team{} = team, [option | rest]) do
    case option do
      {:limit, limit} ->
        query
        |> limit(^limit)
        |> do_for_team(team, rest)

      {:start_date, start_date} ->
        query
        |> where([g], g.date >= ^start_date)
        |> order_by([g], asc: g.date)
        |> do_for_team(team, rest)

      _ ->
        do_for_team(query, team, rest)
    end
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)
end
