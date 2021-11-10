defmodule OOTPUtility.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias OOTPUtility.Repo

  alias OOTPUtility.Leagues.League
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

  def for_team(team, opts \\ %{})

  def for_team(%Team{id: _id, league: %Ecto.Association.NotLoaded{}} = team, opts) do
    team
    |> Repo.preload(:league)
    |> for_team(opts)
  end

  def for_team(
        %Team{id: id, league: %League{current_date: current_league_date}} = _team,
        %{recent: days_in_past}
      ) do
    cutoff_date = Timex.subtract(current_league_date, Timex.Duration.from_days(days_in_past))

    Game
    |> where([g], g.away_team_id == ^id or g.home_team_id == ^id)
    |> where([g], g.played == true)
    |> where([g], g.date > ^cutoff_date)
    |> order_by([g], g.date)
    |> limit(10)
    |> preload([g], [:away_team, :home_team, :winning_pitcher, :losing_pitcher, :save_pitcher])
    |> Repo.all()
  end

  def for_team(%Team{id: id} = _team, %{}) do
    Game
    |> where([g], g.away_team_id == ^id or g.home_team_id == ^id)
    |> order_by([g], g.date)
    |> Repo.all()
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
