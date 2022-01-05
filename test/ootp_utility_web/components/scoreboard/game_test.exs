defmodule OOTPUtilityWeb.Components.Scoreboard.GameTest do
  use OOTPUtilityWeb.ComponentCase, async: true

  alias OOTPUtilityWeb.Components.Scoreboard.Game

  test_snapshot "returns a summary of a played game" do
    home_team = insert(:team, %{name: "Home Team", abbr: "HT", logo_filename: "home_team.png"})

    winning_pitcher =
      build(:player, %{
        first_name: "Winning",
        last_name: "Pitcher",
        position: "SP",
        team: home_team
      })

    away_team = insert(:team, %{name: "Away Team", abbr: "AT", logo_filename: "away_team.png"})

    losing_pitcher =
      build(:player, %{first_name: "Losing", last_name: "Pitcher", position: "MR", team: away_team})

    save_pitcher =
      build(:player, %{first_name: "Save", last_name: "Pitcher", position: "CL", team: home_team})

    game =
      insert(:completed_game,
        home_team: home_team,
        away_team: away_team,
        home_team_runs: 4,
        away_team_runs: 2,
        winning_pitcher: winning_pitcher,
        losing_pitcher: losing_pitcher,
        save_pitcher: save_pitcher
      )

    render_surface do
      ~F"""
        <Game id={"#{game.id}-game"} game={game} />
      """
    end
  end
end
