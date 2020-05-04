defmodule OOTPUtility.Game.Log.LineTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Fixtures
  alias OOTPUtility.Game.Log.Line

  describe "format_raw_text" do
    test "formats the string" do
      {fixtures, _} = Code.eval_file("test/support/fixtures/line_formatting_fixtures.ex")

      for {{raw, formatted}, index} <- Enum.with_index(fixtures) do
        with line_attrs <- %{text: raw, line: Integer.to_string(index)},
             %Line{formatted_text: formatted_text} <- Fixtures.create_game_log_line(line_attrs) do
          assert formatted_text == formatted
        end
      end
    end
  end

  describe "for_game" do
    test "returns all of the lines that are associated with the specified game ID" do
      log_lines_for_game = [
        Fixtures.create_game_log_line(%{game_id: 1, line: 1}),
        Fixtures.create_game_log_line(%{game_id: 1, line: 2})
      ]

      log_line_for_different_game = Fixtures.create_game_log_line(%{game_id: 2})

      assert Repo.all(Line.for_game(Line, 1)) == log_lines_for_game
      assert Enum.all?(Repo.all(Line.for_game(Line, 1)), fn l -> l.game_id == 1 end)
      assert Repo.one(Line.for_game(Line, 2)) == log_line_for_different_game
    end
  end
end
