defmodule OOTPUtility.GamesTest do
  use OOTPUtility.DataCase, async: true

  import OOTPUtility.Factory

  alias OOTPUtility.Games

  describe "games" do
    setup do
      {:ok, game: insert(:game)}
    end

    test "list_games/0 returns all games", %{game: game} do
      assert ids_for(Games.list_games()) == ids_for([game])
    end

    test "get_game!/1 returns the game with given id", %{game: game} do
      assert Games.get_game!(game.id).id == game.id
    end
  end

  describe "for_team/2" do
    setup do
      league = insert(:league, current_date: Timex.today())
      team = insert(:team, league: league)

      {:ok, league: league, team: team}
    end

    test "returns all games related to a team when give no options", %{team: team, league: league} do
      games = [
        insert(:game, home_team: team, league: league),
        insert(:game, away_team: team, league: league)
      ]

      assert ids_for(Games.for_team(team)) == ids_for(games)
    end

    test "returns the games played by the team before or on :start_date", %{
      team: team,
      league: league
    } do
      past_date = date_in_past(20)
      old_game = insert(:game, league: league, date: past_date) |> complete_game()

      recent_games =
        1..10
        |> Enum.take(3)
        |> Enum.map(fn
          date ->
            insert(:game, home_team: team, league: league, date: date_in_past(date))
            |> complete_game()
        end)

      games_in_past_ten_days = Games.for_team(team, start_date: date_in_past(10))

      assert Enum.sort(ids_for(games_in_past_ten_days)) == Enum.sort(ids_for(recent_games))

      refute Enum.any?(games_in_past_ten_days, &(&1.id == old_game.id))
    end

    test "returns n games specified by :limit", %{team: team, league: league} do
      [game | _rest] =
        games =
        Enum.map(1..3, fn
          _ -> insert(:game, home_team: team, league: league)
        end)

      assert team |> Games.for_team() |> ids_for() == ids_for(games)

      assert ids_for(Games.for_team(team, limit: 1)) == [game.id]
    end
  end

  defp date_in_past(days_ago) do
    with days_ago_duration <- Timex.Duration.from_days(days_ago) do
      Timex.today()
      |> Timex.subtract(days_ago_duration)
    end
  end
end
