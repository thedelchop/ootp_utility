defmodule OOTPUtilityWeb.Components.Statistics.LeaderboardTest do
  @moduledoc """
    Snapshot tests for the Leaderboard component.

    This test is only meant to ensure that I'm not inadvertently changing the
    way that a Leaderboard is rendered, so, instead of creating a
  """
  use OOTPUtilityWeb.ComponentCase, async: true

  alias OOTPUtilityWeb.Components.Statistics.Leaderboard
  alias OOTPUtility.Statistics

  test_snapshot "Renders a leaderboard using the set of leaders passed into it" do
    league = insert(:league, season_year: 2023)

    team = insert(:team, league: league)

    insert(:player_batting_stats,
      player:
        insert(:player,
          first_name: "Wade",
          last_name: "Boggs",
          position: :third_base,
          team: team
        ),
      home_runs: 30,
      runs_batted_in: 80,
      runs: 105,
      batting_average: 0.275
    )

    insert(:player_batting_stats,
      player:
        insert(:player,
          first_name: "Barry",
          last_name: "Bonds",
          position: :left_field,
          team: team
        ),
      home_runs: 10,
      runs_batted_in: 40,
      runs: 150,
      batting_average: 0.342
    )

    insert(:player_batting_stats,
      player:
        insert(:player,
          first_name: "Babe",
          last_name: "Ruth",
          position: :right_field,
          team: team
        ),
      home_runs: 55,
      runs_batted_in: 180,
      runs: 105,
      batting_average: 0.305
    )

    leaders = [
      Statistics.team_leaders(team, :home_runs),
      Statistics.team_leaders(team, :runs_batted_in),
      Statistics.team_leaders(team, :runs),
      Statistics.team_leaders(team, :batting_average)
    ]

    render_surface do
      ~F"""
        <Leaderboard leaders={leaders} />
      """
    end
  end
end
