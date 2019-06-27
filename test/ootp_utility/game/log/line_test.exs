defmodule OOTPUtility.Game.Log.LineTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.{Fixtures, Repo, Game.Log.Line}

  describe "unformatted" do
    test "returns a query which includes any unformatted log lines" do
      Fixtures.create_game_log_line(%{raw_text: "0-0: Ball"})
      unformatted_line = Fixtures.create_game_log_line(%{formatted_text: nil})

      results = Repo.all(Line.unformatted)

      assert Enum.member?(results, unformatted_line) 

      assert Enum.count(results) == 1
    end

    test "returns a query which excludes any formatted log lines" do
      Fixtures.create_game_log_line(%{formatted_text: nil})
      formatted_line = Fixtures.create_game_log_line(%{raw_text: "0-0: Ball"})

      results = Repo.all(Line.unformatted)

      refute Enum.member?(results, formatted_line) 

      assert Enum.count(results) == 1
    end
  end

  describe "pitch_descriptions" do
    test "returns a query which includes any log lines that are descriptions of pitches" do
      Fixtures.create_game_log_line(%{type: 1})
      pitch_description = Fixtures.create_game_log_line(%{type: 3})

      results = Repo.all(Line.pitch_descriptions)

      assert Enum.member?(results, pitch_description) 

      assert Enum.count(results) == 1
    end

    test "returns a query which excludes any log lines that are not descriptions of pitches" do
      at_bat_setup = Fixtures.create_game_log_line(%{type: 1})
      Fixtures.create_game_log_line(%{type: 3})

      results = Repo.all(Line.pitch_descriptions)

      refute Enum.member?(results, at_bat_setup) 

      assert Enum.count(results) == 1
    end
  end

  describe "#raw_text" do
    test "returns a query that selects all of the raw text from the log lines" do
      foul_ball = Fixtures.create_game_log_line(%{raw_text: "0-0: Foul Ball, (location: 2F)"})
      strike_out = Fixtures.create_game_log_line(%{raw_text: "1-2: Strikes Out Looking"})

      results = Repo.all(Line.raw_text)

      assert Enum.member?(results, foul_ball.raw_text)
      assert Enum.member?(results, strike_out.raw_text)

      assert Enum.count(results) == 2
    end
  end

  describe "#format_raw_text" do

    @formattable_strings [
      {"0-0: Foul Ball, (location: 2F)", "0-0: Strike (Foul Ball, 2F)" },
      {"1-0: Called Strike", "1-0: Strike (Looking)" }
    ]

    test "formats the string" do
      for {raw, formatted} <- @formattable_strings do
        formatted_line =  Fixtures.create_game_log_line(%{raw_text: raw})
                          |> Line.format_raw_text

        assert formatted_line == formatted
      end
    end

    test "returns nil if the string was not formatted" do
      formatted_line =  Fixtures.create_game_log_line(%{raw_text: "UNRECOGNIZED GAME EVENT"})
                        |> Line.format_raw_text

      assert is_nil(formatted_line)
    end
    
  end
end
