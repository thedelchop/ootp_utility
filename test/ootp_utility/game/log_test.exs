defmodule OOTPUtility.Game.LogTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Fixtures
  alias OOTPUtility.Game.Log

  describe "unformatted_lines" do
    test "returns all of the raw_text from all lines which are not formatted" do
      foul_ball = Fixtures.create_game_log_line(%{raw_text: "0-0: Foul Ball, (location: 2F)", formatted_text: nil})
      strike_out = Fixtures.create_game_log_line(%{raw_text: "1-2: Strikes Out Looking", formatted_text: nil})

      lines = Log.unformatted_lines()

      assert Enum.member?(lines, foul_ball.raw_text)
      assert Enum.member?(lines, strike_out.raw_text)
    end
  end
end
