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
end
