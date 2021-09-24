defmodule OOTPUtility.GamesTest do
  use OOTPUtility.DataCase
  alias OOTPUtility.Games

  describe "games" do
    import OOTPUtility.GamesFixtures

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
end
