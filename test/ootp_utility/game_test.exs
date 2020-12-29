defmodule OOTPUtility.GameTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.{Fixtures, Game}

  setup do
    game_lines = [
      Fixtures.create_game_log_line(%{game_id: 1, line: 1}),
      Fixtures.create_game_log_line(%{game_id: 1, line: 2})
    ]

    {:ok, game_lines: game_lines}
  end

  describe "new/1" do
    test "returns a Game.t() struct with the specific game_id" do
      assert match?(
               %Game{
                 id: 1
               },
               Game.new(1)
             )
    end
  end

  describe "new/2" do
    test "returns a Game.t() struct with the related Game.Log.t()", %{game_lines: game_lines} do
      assert match?(
               %Game{
                 log: %Game.Log{
                   game_id: 1,
                   lines: ^game_lines
                 }
               },
               Game.new(1)
             )
    end
  end
end
