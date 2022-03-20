defmodule OOTPUtility.Statistics.Batting do
  @moduledoc """
  The Statistics.Batting context.
  """
  import Ecto.Query, warn: false

  alias __MODULE__
  alias OOTPUtility.{Repo, Players, Teams, Leagues, Statistics}

  @doc """
  Returns the Statistics.Batting.Player struct or structs for the Player
  or Players passed in. The query takes the following options:
    * `year` - The league year to filter the player's statistics by (Default: The player's league's current season yearh)
    * `team` - A %Team{} or its ID, for which to filter the statistics by. (Default: The player's team)
    * `level` - A %League.Level{} or its :atom, for which to filter the statistics by. (Default: :major)
    * `split` - The split to return for the statistics [:all, :left, :right], (Default: :all)

  To override a default, simply pass in a option with the specified key, and to remove an option from the query all together,
  simply pass in `nil`.

  When passing in a list of players, the options will be built by using the first player in the list passed in, so override
  any options you need to change if that comparison doesn't work.
  """

  @type for_player_options :: [
          year: integer(),
          team: Teams.Team.t() | String.t(),
          level: Leagues.Level.t() | atom(),
          split: :all | :left | :right
        ]

  @spec for_player(Players.Player.t() | [Players.Player.t()], for_player_options()) ::
          Statistics.Batting.Player.t() | [Statistics.Batting.Player.t()]
  def for_player(player_or_players, opts \\ Keyword.new())
  def for_player([], _opts), do: []

  def for_player([player | _] = players, opts) when is_list(players) do
    player_ids = Enum.map(players, & &1.id)

    [bs]
    |> dynamic(bs.player_id in ^player_ids)
    |> do_for_player(options_for_player(player, opts))
    |> Repo.all()
  end

  def for_player(player, opts) do
    stats =
      [bs]
      |> dynamic(bs.player_id == ^player.id)
      |> do_for_player(options_for_player(player, opts))
      |> Repo.all()

    case stats do
      [] ->
        nil

      [stat] ->
        stat

      stats ->
        stats
    end
  end

  @spec team_leaders(Teams.Team.t(), atom()) :: Statistics.Leaderboard.t()
  def team_leaders(%Teams.Team{league: %Ecto.Association.NotLoaded{}} = team, statistic) do
    team
    |> Repo.preload(:league)
    |> team_leaders(statistic)
  end

  def team_leaders(
        %Teams.Team{
          league: %Leagues.League{
            season_year: year,
            level: level
          }
        } = team,
        statistic
      ) do
    [level: level, year: year, team: team, split: :all]
    |> build_player_query()
    |> Statistics.Leaderboard.new(statistic)
  end

  defp do_for_player(query \\ Batting.Player, player_clause, opts) do
    query
    |> build_player_query(opts)
    |> where(^player_clause)
    |> order_by([bs], bs.player_id)
  end

  defp build_player_query(query \\ Batting.Player, opts)

  defp build_player_query(query, []), do: query

  # credo:disable-for-next-line Credo.Check.Refactor.CyclomaticComplexity
  defp build_player_query(query, [option | rest]) do
    case option do
      {_, :any} ->
        build_player_query(query, rest)

      {:year, year} ->
        query
        |> where([bs], bs.year == ^year)
        |> build_player_query(rest)

      {:team, %Teams.Team{id: team_id}} ->
        query
        |> where([bs], bs.team_id == ^team_id)
        |> build_player_query(rest)

      {:team, team_id} ->
        query
        |> where([bs], bs.team_id == ^team_id)
        |> build_player_query(rest)

      {:split, split} ->
        query
        |> where([bs], bs.split == ^split)
        |> build_player_query(rest)

      {:league, %Leagues.League{id: league_id}} ->
        query
        |> where([bs], bs.league_id == ^league_id)
        |> build_player_query(rest)

      {:league, league_id} ->
        query
        |> where([bs], bs.league_id == ^league_id)
        |> build_player_query(rest)

      {:level, %Leagues.Level{id: level} = _level} ->
        query
        |> where([bs], bs.level == ^level)
        |> build_player_query(rest)

      {:level, level} ->
        query
        |> where([bs], bs.level == ^level)
        |> build_player_query(rest)

      _ ->
        build_player_query(query, rest)
    end
  end

  defp options_for_player(%Players.Player{team: %Ecto.Association.NotLoaded{}} = player, opts) do
    player
    |> Repo.preload(:team)
    |> options_for_player(opts)
  end

  defp options_for_player(%Players.Player{league: %Ecto.Association.NotLoaded{}} = player, opts) do
    player
    |> Repo.preload(:league)
    |> options_for_player(opts)
  end

  defp options_for_player(
         %Players.Player{
           league: %Leagues.League{season_year: year} = _league,
           team: %Teams.Team{} = team
         } = _player,
         opts
       ) do
    opts
    |> Keyword.put_new(:year, year)
    |> Keyword.put_new(:team, team)
    |> Keyword.put_new(:split, :all)
  end
end
