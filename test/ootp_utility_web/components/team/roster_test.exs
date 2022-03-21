defmodule OOTPUtilityWeb.Components.Team.RosterTest do
  @moduledoc """
    Snapshot tests for the Leaderboard component.

    This test is only meant to ensure that I'm not inadvertently changing the
    way that a Leaderboard is rendered, so, instead of creating a
  """
  use OOTPUtilityWeb.ComponentCase, async: true

  alias OOTPUtilityWeb.Components.Team.Roster

  @player_attributes [:first_name, :last_name, :throws, :bats, :position]

  test_snapshot "Renders a roster for the specified team" do
    league = insert(:league, season_year: 2023)
    team = insert(:team, league: league, conference: nil, division: nil)

    seed_team_with_players(team, league)

    render_surface do
      ~F"""
      <Roster id={"#{team.slug}-roster"} team={team} year={league.season_year} />
      """
    end
  end

  defp seed_team_with_players(team, league) do
    create_player_with_pitching_stats(
      %{first_name: "Cy", last_name: "Young", position: "SP", throws: "left"},
      team,
      league
    )

    create_player_with_pitching_stats(
      %{first_name: "Roger", last_name: "Clemens", position: "SP", throws: "right"},
      team,
      league
    )

    create_player_with_pitching_stats(
      %{first_name: "Catfish", last_name: "Hunter", position: "MR", throws: "left"},
      team,
      league
    )

    create_player_with_pitching_stats(
      %{first_name: "Mariano", last_name: "Rivera", position: "CL", throws: "right"},
      team,
      league
    )

    create_player_with_batting_stats(
      %{first_name: "Yogi", last_name: "Berra", position: "C", bats: "right"},
      team,
      league
    )

    create_player_with_batting_stats(
      %{first_name: "Jimmie", last_name: "Fox", position: "1B", bats: "right"},
      team,
      league
    )

    create_player_with_batting_stats(
      %{first_name: "Wade", last_name: "Boggs", position: "3B", bats: "right"},
      team,
      league
    )

    create_player_with_batting_stats(
      %{first_name: "Manny", last_name: "Ramiriez", position: "LF", bats: "right"},
      team,
      league
    )

    create_player_with_batting_stats(
      %{first_name: "Andruw", last_name: "Jones", position: "CF", bats: "left"},
      team,
      league
    )

    create_player_with_batting_stats(
      %{first_name: "Babe", last_name: "Ruth", position: "RF", bats: "left"},
      team,
      league
    )
  end

  def create_player_with_pitching_stats(attrs, team, league) do
    stats_attrs =
      attrs
      |> Enum.into(%{
        games: 28,
        games_started: 25,
        outs_pitched: 752,
        wins: 23,
        losses: 2,
        saves: 0,
        strikeouts: 350,
        walks: 50,
        runs: 100,
        earned_run_average: 2.54,
        walks_hits_per_inning_pitched: 0.54,
        wins_above_replacement: 10.1
      })
      |> build_stats_attributes(team, league)

    insert(:player_pitching_stats, stats_attrs)
  end

  def create_player_with_batting_stats(attrs, team, league) do
    stats_attrs =
      attrs
      |> Enum.into(%{
        games: 28,
        at_bats: 300,
        hits: 100,
        home_runs: 20,
        runs_batted_in: 100,
        walks: 50,
        strikeouts: 100,
        stolen_bases: 10,
        batting_average: 0.333,
        on_base_percentage: 0.375,
        slugging: 0.480,
        wins_above_replacement: 8.3
      })
      |> build_stats_attributes(team, league)

    insert(:player_batting_stats, stats_attrs)
  end

  defp build_stats_attributes(attrs, team, league) do
    player_attrs =
      attrs
      |> Map.take(@player_attributes)
      |> Map.put(:team, team)

    attrs
    |> Map.put(:league, league)
    |> Map.put(:team, team)
    |> Map.put(:player, build(:player, player_attrs))
    |> Map.drop(@player_attributes)
  end
end
