defmodule OOTPUtilityWeb.Components.Team.LeadersTest do
  use OOTPUtilityWeb.ComponentCase, async: true

  alias OOTPUtilityWeb.Components.Team.Leaders

  test_snapshot "Renders a leaderboard using the set of leaders passed into it" do
    league = insert(:league, season_year: 2023)

    team = insert(:team, league: league)

    create_team_batting_stats(team)

    create_team_pitching_stats(team)

    render_surface do
      ~F"""
        <Leaders id= {"#{team.slug}-leaderboard"} team={team} />
      """
    end
  end

  defp create_team_pitching_stats(team) do
    insert(:player_pitching_stats,
      player:
        insert(:player,
          first_name: "Craig",
          last_name: "Kimbrel",
          position: :middle_reliever,
          team: team
        ),
      wins: 10,
      saves: 5,
      earned_run_average: 2.45,
      strikeouts: 50,
      walks_hits_per_inning_pitched: 1.22
    )

    insert(:player_pitching_stats,
      player:
        insert(:player,
          first_name: "Trevor",
          last_name: "Hoffman",
          position: :closer,
          team: team
        ),
      wins: 1,
      saves: 50,
      earned_run_average: 1.85,
      strikeouts: 70,
      walks_hits_per_inning_pitched: 0.82
    )

    insert(:player_pitching_stats,
      player:
        insert(:player,
          first_name: "Jonathan",
          last_name: "Papelbon",
          position: :closer,
          team: team
        ),
      wins: 3,
      saves: 37,
      earned_run_average: 3.17,
      strikeouts: 100,
      walks_hits_per_inning_pitched: 1.73
    )

    insert(:player_pitching_stats,
      player:
        insert(:player,
          first_name: "Rod",
          last_name: "Beck",
          position: :middle_reliever,
          team: team
        ),
      wins: 7,
      saves: 12,
      earned_run_average: 4.45,
      strikeouts: 75,
      walks_hits_per_inning_pitched: 1.55
    )
  end

  defp create_team_batting_stats(team) do
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
      batting_average: 0.275,
      stolen_bases: 10
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
      batting_average: 0.342,
      stolen_bases: 20
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
      batting_average: 0.305,
      stolen_bases: 8
    )
  end
end
