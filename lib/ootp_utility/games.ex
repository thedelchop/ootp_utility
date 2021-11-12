defmodule OOTPUtility.Games do
  @moduledoc """
  The Games context.
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
  def list_games do
    Repo.all(Game)
  end

  def for_team(team, opts \\ Keyword.new)

  def for_team(%Team{id: _id, league: %Ecto.Association.NotLoaded{}} = team, opts) do
    team
    |> Repo.preload(:league)
    |> for_team(opts)
  end

  def for_team(%Team{} = team, opts) do
    games = do_for_team(team, opts)

    if Keyword.has_key?(opts, :start_date), do: Enum.reverse(games), else: games
  end

  def do_for_team(query \\ Game, team, opts)

  def do_for_team(query, %Team{id: id} = _team, []) do
    query
    |> where([g], g.away_team_id == ^id or g.home_team_id == ^id)
    |> preload([g], [:away_team, :home_team, :winning_pitcher, :losing_pitcher, :save_pitcher])
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
        |> order_by([g], desc: g.date)
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
