defmodule OOTPUtility.Statistics do
  @moduledoc """
  This module provides an interface for dealing with statistics
  """

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

  defguard is_batting_stat(stat) when stat in @batting_statistics
  defguard is_pitching_stat(stat) when stat in @pitching_statistics

  alias OOTPUtility.{Repo, Teams, Leagues}
  alias Ecto.Association.NotLoaded

  alias OOTPUtility.Statistics.Batting, as: BattingStats
  alias OOTPUtility.Statistics.Pitching, as: PitchingStats
  alias OOTPUtility.Statistics.Leaderboard

  import Ecto.Query

  def team_ranking(%Teams.Team{league: %NotLoaded{}} = team, statistic) do
    team
    |> Repo.preload(:league)
    |> team_ranking(statistic)
  end

  def team_ranking(%Teams.Team{} = team, stat) when is_batting_stat(stat) do
    do_team_ranking(team, stat, :league, BattingStats.Team)
  end

  def team_ranking(%Teams.Team{} = team, stat) when is_pitching_stat(stat) do
    stat = stat |> Atom.to_string() |> String.replace("_allowed", "") |> String.to_atom()

    do_team_ranking(team, stat, :league, PitchingStats.Team)
  end

  def team_leaders(%Teams.Team{league: %NotLoaded{}} = team, statistic) do
    team
    |> Repo.preload(:league)
    |> team_leaders(statistic)
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
      when is_batting_stat(stat) do
    scope = dynamic([stats], stats.team_id == ^team_id and stats.year == ^year)

    Leaderboard.new(BattingStats.Player, stat, scope)
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
    scope = dynamic([stats], stats.team_id == ^team_id and stats.year == ^year)

    Leaderboard.new(PitchingStats.Player, stat, scope)
  end

  defp do_team_ranking(%Teams.Team{id: team_id} = _team, statistic, partition, schema) do
    order_by = [desc: statistic]
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
end
