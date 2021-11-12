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
    setup do
      league = league_fixture(%{current_date: Timex.today()})
      team = team_fixture(%{name: "Team"}, league)

      {:ok, league: league, team: team}
    end

    test "returns all games related to a team when give no options", %{team: team, league: league} do
      games = [
        create_game(team, league),
        create_game(%{away_team: team}, team, league)
      ]

      assert ids_for(Games.for_team(team)) == ids_for(games)
    end

    test "returns the games played by the team before or on :start_date", %{team: team, league: league} do
      old_game = create_played_game(team, league, 20)

      recent_games =
        1..10
        |> Enum.take(3)
        |> Enum.map(&create_played_game(team, league, &1))

      games_in_past_ten_days = Games.for_team(team, start_date: date_in_past(10))

      assert Enum.sort(ids_for(games_in_past_ten_days)) == Enum.sort(ids_for(recent_games))

      refute Enum.any?(games_in_past_ten_days, & &1.id == old_game.id)
    end

    test "returns n games specified by :limit", %{team: team, league: league} do
      [game | _rest] = games = Enum.map(1..3, fn
        _ -> create_game(team, league)
      end)

      assert team |> Games.for_team() |> ids_for() == ids_for(games)

      assert ids_for(Games.for_team(team, limit: 1)) == [game.id]
    end
  end

  defp ids_for(games) do
    Enum.map(games, & &1.id)
  end

  defp create_played_game(team, league, days_ago \\ 0) do
    create_game(%{date: date_in_past(days_ago), played: true}, team, league)
  end

  defp create_game(attrs \\ %{}, team, league)  do
    attrs
    |> Enum.into(%{
      home_team: team,
      league: league
    })
    |> game_fixture()
  end

  defp date_in_past(days_ago) do
    with days_ago_duration <- Timex.Duration.from_days(days_ago) do
      Timex.today()
      |> Timex.subtract(days_ago_duration)
    end
  end
end
