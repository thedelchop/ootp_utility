defmodule OOTPUtility.GamesTest do
  use OOTPUtility.DataCase

  import OOTPUtility.GamesFixtures
  import OOTPUtility.LeaguesFixtures
  import OOTPUtility.TeamsFixtures

  alias OOTPUtility.Games

  describe "games" do
    setup do
      {:ok, game: game_fixture()}
    end

    test "list_games/0 returns all games", %{game: game} do
      assert Games.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id", %{game: game} do
      assert Games.get_game!(game.id) == game
    end
  end

  describe "for_team/2" do
    test "returns all games related to a team when give no options" do
      team = team_fixture(%{name: "Team"})
      opponent = team_fixture(%{name: "Opponent"})

      games = [
        game_fixture(%{home_team: team, away_team: opponent}),
        game_fixture(%{home_team: opponent, away_team: team})
      ]

      assert Games.for_team(team) == games
    end

    test "returns the last 10 games played by the team in the last N days when the `recent` option is given" do
      current_date = Timex.today()

      league = league_fixture(%{current_date: current_date})
      team = team_fixture(%{name: "Team", league_id: league.id})

      recent_games = Enum.map([6, 4, 2], fn
        days_ago ->
          days_ago = Timex.Duration.from_days(days_ago)

          game_fixture(%{
            home_team: team,
            date: Timex.subtract(current_date, days_ago),
            played: true,
            league: league
          })
        end)

      old_game = game_fixture(%{
        home_team: team,
        date: Timex.subtract(current_date, Timex.Duration.from_days(20)),
        league: league,
        played: true
      })

      assert Games.for_team(team, %{recent: 10}) == recent_games

      refute Enum.any?(Games.for_team(team, %{recent: 10}), & &1.id == old_game.id)
    end
  end
end
