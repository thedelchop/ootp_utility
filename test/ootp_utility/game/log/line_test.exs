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

    # These are example strings from the actual dataset, which should give me a good feel for if I'm catching all the cases
    @formattable_strings [
      {"0-0: Foul Ball, (location: 2F)", "0-0: Strike (Foul Ball, 2F)" },
      {"1-0: Bunted foul", "1-0: Strike (Foul Ball, 2F)"},
      {"1-0: Called Strike", "1-0: Strike (Called)" },
      {"1-0: Swinging Strike", "1-0: Strike (Swinging)" },
      {"1-1: Ball", "1-1: Ball" },
      {"2-2: Strikes out swinging", "2-2: Strikeout (Swinging)" },
      {"1-0: Fly out, F8 (Line Drive, 8RM)", "1-0: Fly out, F8, (Line Drive, 8RM)"},
      {"0-0: Fly out, F3 (Popup, 3)", "0-0: Fly out, F3, (Popup, 3)"},
      {"0-1: Fly out, F1 (Line Drive, P)", "0-1: Fly out, F1, (Line Drive, P)"},
      {"3-2: Ground out 1-6-3 (Groundball, 15S)", "3-2: Ground out, 1-6-3, (Groundball, 15S)"},
      {"2-2: Ground out U3 (Groundball, 3S)", "2-2: Ground out, U3, (Groundball, 3S)"},
      {"1-0: Ground out 1-3 (Groundball, P)", "1-0: Ground out, 1-3, (Groundball, P)"},
      {"0-1:  GRAND SLAM HOME RUN  (Flyball, 7D), Distance : 391 ft", "0-1: Home Run, 4R, (Flyball, 7D, 391 ft)"},
      {"3-2:  3-RUN HOME RUN  (Flyball, 78XD), Distance : 391 ft", "3-2: Home Run, 3R, (Flyball, 78XD, 391 ft)"},
      {"2-1:  2-RUN HOME RUN  (Flyball, 7LD), Distance : 344 ft", "2-1: Home Run, 2R, (Flyball, 7LD, 344 ft)"},
      {"0-0:  SOLO HOME RUN  (Flyball, 9LD), Distance : 341 ft", "0-0: Home Run, 1R, (Flyball, 9LD, 341 ft)"},
      {"1-0: SINGLE  (Flyball, 8RS)", "1-0: Single, (Flyball, 8RS)"},
      {"2-0: SINGLE  (Groundball, 56D)", "2-0: Single, (Groundball, 56D)"},
      {"1-0: SINGLE  (Line Drive, 8RS)", "1-0: Single, (Line Drive, 8RS)"},
      {"2-1: SINGLE  (Flyball, 8RS) - OUT at second base trying to stretch hit.", "2-1: Single, (Flyball, 8RS), [2B]"},
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
