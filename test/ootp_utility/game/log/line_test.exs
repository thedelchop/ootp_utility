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
    setup do
      game_lines = [
        Fixtures.create_game_log_line(%{game_id: 1, line: 1}),
        Fixtures.create_game_log_line(%{game_id: 1, line: 2})
      ]

      other_game_line = Fixtures.create_game_log_line(%{game_id: 2})

      {:ok, game_lines: game_lines, other_game_line: other_game_line}
    end

    test "returns all of the lines that are associated with the specified game ID", %{
      game_lines: game_lines,
      other_game_line: other_game_line
    } do
      assert Repo.all(Line.for_game(1)) == game_lines
      assert Enum.all?(Repo.all(Line.for_game(1)), fn l -> l.game_id == 1 end)
      assert Repo.one(Line.for_game(2)) == other_game_line
    end

    test "the lines returned for the game are ordered by line number", %{
      game_lines: [first_game_line, second_game_line]
    } do
      [first_line, second_line] = Repo.all(Line.for_game(1))

      assert first_line == first_game_line
      assert second_line == second_game_line
    end
  end
end
