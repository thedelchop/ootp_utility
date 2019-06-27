defmodule OOTPUtility.Game.LogTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Fixtures
  alias OOTPUtility.Game.Log
  alias OOTPUtility.Game.Log.Line

  describe "unformatted_lines" do
    test "returns all of the raw_text from all lines which are not formatted" do
      foul_ball = Fixtures.create_game_log_line(%{raw_text: "0-0: Foul Ball, (location: 2F)", formatted_text: nil})
      strike_out = Fixtures.create_game_log_line(%{raw_text: "1-2: Strikes Out Looking", formatted_text: nil})

      lines = Log.unformatted_lines()

      assert Enum.member?(lines, foul_ball.raw_text)
      assert Enum.member?(lines, strike_out.raw_text)
    end
  end

  describe "format_lines" do
    test "it formats all Lines for whom the \"formatted_text\" can be produced" do
      formattable_line = Fixtures.create_game_log_line(%{raw_text: "0-0: Foul Ball, (location: 2F)", formatted_text: nil})
      unformattable_line = Fixtures.create_game_log_line(%{raw_text: "1-2: Caught stealing home!", formatted_text: nil})

      Log.format_lines

      assert not(is_nil(Repo.get(Line, formattable_line.id).formatted_text))
      assert is_nil(Repo.get(Line, unformattable_line.id).formatted_text)
    end

    test "it only formats Lines who are included in the query if a query was included" do
      formattable_line = Fixtures.create_game_log_line(%{raw_text: "0-0: Foul Ball, (location: 2F)", formatted_text: nil})
      formattable_but_skipped_line = Fixtures.create_game_log_line(%{raw_text: "0-1: Foul Ball, (location: 2F)", formatted_text: nil})
      unformattable_line = Fixtures.create_game_log_line(%{raw_text: "1-2: Caught stealing home!", formatted_text: nil})

      Log.format_lines(from l in Line, where: l.id in [^formattable_line.id, ^unformattable_line.id])

      assert not(is_nil(Repo.get(Line, formattable_line.id).formatted_text))
      assert is_nil(Repo.get(Line, formattable_but_skipped_line.id).formatted_text)
      assert is_nil(Repo.get(Line, unformattable_line.id).formatted_text)
    end
  end
end
