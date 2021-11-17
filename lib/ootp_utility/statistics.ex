defmodule OOTPUtility.Statistics do
  @moduledoc """
  This module provides an interface for dealing with statistics
  """
  alias OOTPUtility.{Repo, Teams, Leagues}

  alias OOTPUtility.Statistics.Batting, as: BattingStats
  alias OOTPUtility.Statistics.Pitching, as: PitchingStats
  alias OOTPUtility.Statistics.Leaderboard

  import Ecto.Query

  def team_leaders(%Teams.Team{league: %Ecto.Association.NotLoaded{}} = team, statistic) do
    team
    |> Repo.preload(:league)
    |> team_leaders(statistic)
  end

  def team_leaders(%Teams.Team{league: %Leagues.League{season_year: year}} = team, statistic) do
    leaders(team, year, statistic)
  end

  def leaders(team, year, :batting_average) do
    batting_leaders_for(team, year, :batting_average)
  end

  def leaders(team, year, :home_runs) do
    batting_leaders_for(team, year, :home_runs)
  end

  def leaders(team, year, :runs_batted_in) do
    batting_leaders_for(team, year, :runs_batted_in)
  end

  def leaders(team, year, :runs) do
    batting_leaders_for(team, year, :runs)
  end

  def leaders(team, year, :stolen_bases) do
    batting_leaders_for(team, year, :stolen_bases)
  end

  def leaders(team, year, :wins) do
    pitching_leaders_for(team, year, :wins)
  end

  def leaders(team, year, :saves) do
    pitching_leaders_for(team, year, :saves)
  end

  def leaders(team, year, :earned_run_average) do
    pitching_leaders_for(team, year, :earned_run_average)
  end

  def leaders(team, year, :strikeouts) do
    pitching_leaders_for(team, year, :strikeouts)
  end

  def leaders(team, year, :walks_hits_per_inning_pitched) do
    pitching_leaders_for(team, year, :walks_hits_per_inning_pitched)
  end

  defp batting_leaders_for(%Teams.Team{id: team_id} = _team, year, field) do
    scope = dynamic([stats], stats.team_id == ^team_id and stats.year == ^year)

    Leaderboard.new(BattingStats.Player, field, scope)
  end

  defp pitching_leaders_for(%Teams.Team{id: team_id} = _team, year, field) do
    scope = dynamic([stats], stats.team_id == ^team_id and stats.year == ^year)

    Leaderboard.new(PitchingStats.Player, field, scope)
  end
end
