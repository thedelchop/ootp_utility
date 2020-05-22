defmodule OOTPUtility.Game.LogTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.{Game, Fixtures}

  describe "Log.new/1" do
    setup do
      game_lines = Enum.map(1..8, &Fixtures.create_game_log_line(%{line: &1}))

      game = Game.new(1)

      {:ok, lines: game_lines, game: game}
    end

    test "returns a Log.t() for the specified Game.t() id", %{
      lines: lines_for_game,
      game: %Game{id: game_id}
    } do
      %Game.Log{lines: log_lines} = Game.Log.new(game_id)

      assert log_lines == lines_for_game
    end

    test "returns a Log.t() for the specified Game.t()", %{lines: lines_for_game, game: game} do
      %Game.Log{lines: log_lines} = Game.Log.new(game)

      assert log_lines == lines_for_game
    end

    test "excludes lines that are not associated with the specfied Game.t()", %{game: game} do
      lines_for_different_game =
        Enum.map(1..3, &Fixtures.create_game_log_line(%{game_id: 2, line: &1}))

      %Game.Log{lines: log_lines} = Game.Log.new(game)

      refute Enum.any?(lines_for_different_game, &Enum.member?(log_lines, &1))
    end
  end
end
