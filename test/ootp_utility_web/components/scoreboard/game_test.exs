defmodule OOTPUtilityWeb.Components.Scoreboard.GameTest do
  use OOTPUtilityWeb.ComponentCase, async: true

  alias OOTPUtilityWeb.Components.Scoreboard.Game

  setup do
    home_team =
      insert(:team, name: "Home Team", abbr: "HT", logo_filename: "home_team.png")
      |> with_record(%{games: 10, wins: 8})

    away_team =
      insert(:team, name: "Away Team", abbr: "AT", logo_filename: "away_team.png")
      |> with_record(%{games: 10, wins: 3})

    game =
      insert(:game, %{
        home_team: home_team,
        away_team: away_team
      })

    {:ok, game: game, home_team: home_team, away_team: away_team}
  end

  test_snapshot "returns a summary of an unplayed game", %{game: game} do
    render_surface do
      ~F"""
        <Game id={"#{game.id}-game"} game={game} />
      """
    end
  end

  test_snapshot "returns a summary of a played game", %{game: game, home_team: home_team, away_team: away_team} do
    winning_pitcher =
      build(:player, %{
        first_name: "Winning",
        last_name: "Pitcher",
        position: "SP",
        team: home_team
      })

    losing_pitcher =
      build(:player, first_name: "Losing", last_name: "Pitcher", position: "MR", team: away_team)

    save_pitcher =
      build(:player, first_name: "Save", last_name: "Pitcher", position: "CL", team: home_team)

    completed_game =
      game
      |> complete_game(
          home_team_runs: 4,
          away_team_runs: 2,
          winning_pitcher: winning_pitcher,
          losing_pitcher: losing_pitcher,
          save_pitcher: save_pitcher

      )

    render_surface do
      ~F"""
        <Game id={"#{completed_game.id}-game"} game={completed_game} />
      """
    end
  end
end
