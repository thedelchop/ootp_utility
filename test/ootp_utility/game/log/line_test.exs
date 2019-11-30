defmodule OOTPUtility.Game.Log.LineTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.{Fixtures, Repo}
  alias OOTPUtility.Game.Log.Line

  describe "import_changset" do
    test "it correctly writes the binary ID" do
      line =
        Line.import_changeset(%{
          id: "1-1",
          game_id: "1",
          line: "1",
          type: "3",
          text: "Foul Ball, location: 2F",
          formatted_text: "2-2: Swinging Strike (Foul Ball, 2F)"
        })

      assert line.changes == %{
               id: "1-1",
               game_id: 1,
               line: 1,
               type: 3,
               text: "Foul Ball, location: 2F",
               formatted_text: "2-2: Swinging Strike (Foul Ball, 2F)"
             }
    end
  end

  describe "unformatted" do
    test "returns a query which includes any unformatted log lines" do
      formatted_line = Fixtures.create_game_log_line(%{id: "1-1", text: "0-0: Ball", line: "1"})

      unformatted_line =
        Fixtures.create_game_log_line(%{id: "1-2", formatted_text: nil, line: "2"})

      results = Repo.all(Line.unformatted())

      assert Enum.member?(results, unformatted_line)
      refute Enum.member?(results, formatted_line)

      assert Enum.count(results) == 1
    end
  end

  describe "formatted" do
    test "returns a query which includes any formatted log lines" do
      formatted_line = Fixtures.create_game_log_line(%{id: "1-1", text: "0-0: Ball", line: "1"})

      unformatted_line =
        Fixtures.create_game_log_line(%{id: "1-2", formatted_text: nil, line: "2"})

      results = Repo.all(Line.formatted())

      assert Enum.member?(results, formatted_line)
      refute Enum.member?(results, unformatted_line)

      assert Enum.count(results) == 1
    end
  end

  describe "pitch_descriptions" do
    test "returns a query which includes any log lines that are descriptions of pitches" do
      Fixtures.create_game_log_line(%{id: "1-1", type: "1", line: "1"})
      pitch_description = Fixtures.create_game_log_line(%{id: "1-2", type: "3", line: "2"})

      results = Repo.all(Line.pitch_descriptions())

      assert Enum.member?(results, pitch_description)

      assert Enum.count(results) == 1
    end

    test "returns a query which excludes any log lines that are not descriptions of pitches" do
      at_bat_setup = Fixtures.create_game_log_line(%{id: "1-1", type: "1", line: "1"})
      Fixtures.create_game_log_line(%{id: "1-2", type: "3", line: "2"})

      results = Repo.all(Line.pitch_descriptions())

      refute Enum.member?(results, at_bat_setup)

      assert Enum.count(results) == 1
    end
  end

  describe "#raw_text" do
    test "returns a query that selects all of the raw text from the log lines" do
      foul_ball =
        Fixtures.create_game_log_line(%{
          id: "1-1",
          text: "0-0: Foul Ball, (location: 2F)",
          line: "1"
        })

      strike_out =
        Fixtures.create_game_log_line(%{id: "1-2", text: "1-2: Strikes Out Looking", line: "2"})

      results = Repo.all(Line.raw_text())

      assert Enum.member?(results, foul_ball.text)
      assert Enum.member?(results, strike_out.text)

      assert Enum.count(results) == 2
    end
  end

  describe "#format_raw_text" do
    test "formats the string" do
      {fixtures, _} = Code.eval_file("test/support/fixtures/line_formatting_fixtures.ex")

      for {{raw, formatted}, index} <- Enum.with_index(fixtures) do
        formatted_line =
          %{id: "1-#{Integer.to_string(index)}", text: raw, line: Integer.to_string(index)}
          |> Fixtures.create_game_log_line()
          |> Line.format_raw_text()

        assert formatted_line == formatted
      end
    end

    test "returns nil if the string was not formatted" do
      formatted_line =
        %{text: "UNRECOGNIZED GAME EVENT"}
        |> Fixtures.create_game_log_line()
        |> Line.format_raw_text()

      assert is_nil(formatted_line)
    end
  end
end
