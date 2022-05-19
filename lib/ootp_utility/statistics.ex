defmodule OOTPUtility.Statistics do
  @moduledoc """
  This module provides an interface for dealing with statistics
  """
  @type batting_statistic ::
          :batting_average | :home_runs | :runs_batted_in | :runs | :stolen_bases
  @type pitching_statistic ::
          :runs_allowed
          | :wins
          | :saves
          | :earned_run_average
          | :strikeouts
          | :walks_hits_per_inning_pitched

  @type statistic :: batting_statistic() | pitching_statistic()

  @batting_statistics [
    :batting_average,
    :home_runs,
    :runs_batted_in,
    :runs,
    :stolen_bases
  ]

  @pitching_statistics [
    :runs_allowed,
    :wins,
    :saves,
    :earned_run_average,
    :strikeouts,
    :walks_hits_per_inning_pitched
  ]

  @prevention_statistics [
    :runs_allowed,
    :earned_run_average,
    :walks_hits_per_inning_pitched
  ]

  defguard is_prevention_stat(stat) when stat in @prevention_statistics
  defguard is_batting_stat(stat) when stat in @batting_statistics
  defguard is_pitching_stat(stat) when stat in @pitching_statistics

  alias OOTPUtility.{Games, Leagues, Players, Repo, Teams, Leagues}
  alias Ecto.Association.NotLoaded

  alias OOTPUtility.Statistics.Batting, as: BattingStats
  alias OOTPUtility.Statistics.Pitching, as: PitchingStats
  alias OOTPUtility.Statistics.Leaderboard

  import Ecto.Query

  import OOTPUtility.Players, only: [is_pitcher: 1]

  defdelegate calculate(attrs, stat), to: OOTPUtility.Statistics.Calculations
  defdelegate round(attrs, stat), to: OOTPUtility.Statistics.Calculations

  @type game_logs_for_options :: [
          type: :pitching | :hitting,
          limit: integer(),
          before: Date.t() | nil,
          after: Date.t() | nil
        ]

  @type game_statistics :: BattingStats.Game.t() | PitchingStats.Game.t()

  @doc """
    Returns a list of either %Statistics.Batting.Game{} or %Statistics.Pitching.Game{}
    for the specified player.

    The following options game be provided:

      * `limit`  - Number of game logs to return
      * `before` - Include games which occur on or before this date, defaults to the current league date
      * `after`  - Include games which occur on or after this date, default to nil
  """
  @spec game_logs_for(Players.Player.t(), game_logs_for_options()) :: [game_statistics()]

  def game_logs_for(player, opts \\ [])

  def game_logs_for(%Players.Player{league: %NotLoaded{}} = player, opts) do
    player
    |> Repo.preload(:league)
    |> game_logs_for(opts)
  end

  def game_logs_for(%Players.Player{league: %Leagues.League{current_date: date}} = player, opts) do
    opts_with_defaults =
      cond do
        date_option_missing?(opts) ->
          Keyword.put_new(opts, :before, date)

        true ->
          opts
      end
      |> Keyword.put_new(:limit, 10)

    do_game_logs_for(player, opts_with_defaults)
  end

  defp do_game_logs_for(%Players.Player{} = player, opts) when is_pitcher(player) do
    do_game_logs_for(PitchingStats.Game, player, opts)
  end

  defp do_game_logs_for(%Players.Player{} = player, opts) do
    do_game_logs_for(BattingStats.Game, player, opts)
  end

  defp do_game_logs_for(query, %Players.Player{id: player_id} = _player, []) do
    query
    |> where([gs, _game], gs.player_id == ^player_id)
    |> preload([:player, game: [:away_team, :home_team]])
    |> Repo.all()
  end

  defp do_game_logs_for(query, player, [opt | rest]) do
    case opt do
      {:limit, limit} ->
        query
        |> limit(^limit)
        |> do_game_logs_for(player, rest)

      {:before, date} ->
        query
        |> join(:inner, [gs], game in Games.Game, on: gs.game_id == game.id)
        |> where([_gs, game], game.date <= ^date)
        |> do_game_logs_for(player, rest)

      {:after, date} ->
        query
        |> join(:inner, [gs], game in Games.Game, on: gs.game_id == game.id)
        |> where([_gs, game], game.date >= ^date)
        |> do_game_logs_for(player, rest)

      _ ->
        do_game_logs_for(query, player, rest)
    end
  end

  defp date_option_missing?(opts) do
    not Keyword.has_key?(opts, :before) and not Keyword.has_key?(opts, :after)
  end

  @doc """
    Retuns the ranking for the specified %Teams.Team{} in the specified scope,
    as a tuple of `{rank, value, statistic_name}`

    * The rank of the team compared to the entire population
    * The value for the team with the statistic
    * The name of the statistic that the team is being ranked for

    The `scope` attribute can be any :league, :conference, :division

    iex> Statistics.team_ranking(%Team{}, :home_runs, :league)
    {1, 256, :home_runs}

    iex> Statistics.team_ranking(%Team{}, :batting_average, :division)
    {3, 0.283, :batting_average}

  """
  @spec team_ranking(Teams.Team.t(), statistic()) :: {integer(), number(), atom()}
  def team_ranking(%Teams.Team{league: %NotLoaded{}} = team, statistic) do
    team
    |> Repo.preload(:league)
    |> team_ranking(statistic)
  end

  def team_ranking(%Teams.Team{} = team, stat) when is_batting_stat(stat) do
    do_team_ranking(team, stat, :league, BattingStats.Team)
  end

  def team_ranking(%Teams.Team{} = team, stat) when is_pitching_stat(stat) do
    sort_order = if stat in @prevention_statistics, do: :asc, else: :desc

    stat = stat |> Atom.to_string() |> String.replace("_allowed", "") |> String.to_atom()

    do_team_ranking(team, stat, :league, PitchingStats.Team, sort_order)
  end

  defp do_team_ranking(
         %Teams.Team{id: team_id} = _team,
         statistic,
         partition,
         schema,
         sort_order \\ :desc
       ) do
    order_by = [{sort_order, statistic}]
    partition = [String.to_atom("#{partition}_id"), :year]

    ranking_query =
      from s in schema,
        select: %{
          position: over(rank(), :rankings),
          count: over(count(), :partition),
          id: s.id
        },
        windows: [
          rankings: [partition_by: ^partition, order_by: ^order_by],
          partition: [partition_by: ^partition]
        ],
        group_by: s.id

    query =
      from stats in schema,
        join: r in subquery(ranking_query),
        on: stats.id == r.id,
        select: {r.position, r.count, field(stats, ^statistic)},
        where: stats.team_id == ^team_id

    Repo.one(query)
  end

  @doc """
  Returns a %Statistics.Leaderboard{} for the specified team and statistic

  iex> Statistics.team_leaders(%Teams.Team{}, :batting_average)
  %Statistics.Leaderboard{}
  """
  @spec team_leaders(Teams.Team.t(), statistic()) :: Statistics.Leaderboard.t()
  def team_leaders(team, stat) when is_batting_stat(stat) do
    BattingStats.team_leaders(team, stat)
  end

  def team_leaders(
        %Teams.Team{
          id: team_id,
          league: %Leagues.League{
            season_year: year
          }
        } = _team,
        stat
      )
      when is_pitching_stat(stat) do
    PitchingStats.Player
    |> where([stats], stats.team_id == ^team_id and stats.year == ^year)
    |> Leaderboard.new(stat)
  end
end
