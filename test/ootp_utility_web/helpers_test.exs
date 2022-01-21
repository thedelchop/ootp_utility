defmodule OOTPUtilityWeb.HelpersTest do
  use ExUnit.Case, async: true

  alias OOTPUtilityWeb.Helpers

  describe "friendly_date/1" do
    test "it formats the specified date as MM/DD/YYYY" do
      date = Date.new!(2021, 09, 12)

      assert Helpers.friendly_date(date) == "09/12/2021"
    end
  end

  describe "capitalize_all/1" do
    test "it takes the string and capitalizes each seperate word" do
      assert Helpers.capitalize_all("third base") == "Third Base"
    end

    test "it leaves already capitalized strings as is" do
      assert Helpers.capitalize_all("Third Base") == "Third Base"
    end

    test "it handles atoms correctly as well" do
      assert Helpers.capitalize_all(:third_base) == "Third Base"
    end
  end

  describe "ordanilize/1" do
    test "it returns a string representing the ordinal form of the number" do
      assert Helpers.ordinalize(1) == "1st"
      assert Helpers.ordinalize(2) == "2nd"
      assert Helpers.ordinalize(3) == "3rd"
      assert Helpers.ordinalize(4) == "4th"
      assert Helpers.ordinalize(5) == "5th"
      assert Helpers.ordinalize(6) == "6th"
      assert Helpers.ordinalize(7) == "7th"
      assert Helpers.ordinalize(8) == "8th"
      assert Helpers.ordinalize(9) == "9th"
    end

    test "it handles large numbers correctly" do
      assert Helpers.ordinalize(144) == "144th"
      assert Helpers.ordinalize(1_000_001) == "1000001st"
    end

    test "it handles 0 correctly" do
      assert Helpers.ordinalize(0) == "0th"
    end

    test "it passes through non-valild input" do
      assert Helpers.ordinalize("string") == "string"
    end
  end

  describe "player_rating_as_stars" do
    test "it returns 5.0 for any rating above 77" do
      for n <- 78..80 do
        assert Helpers.player_rating_as_stars(n) == 5.0
      end
    end

    test "it returns 4.5 for any rating above 71 and below 78" do
      for n <- 72..77 do
        assert Helpers.player_rating_as_stars(n) == 4.5
      end
    end

    test "it returns 4.0 for any rating above 74 and below 72" do
      for n <- 65..71 do
        assert Helpers.player_rating_as_stars(n) == 4.0
      end
    end

    test "it returns 3.5 for any rating above 58 and below 65" do
      for n <- 59..64 do
        assert Helpers.player_rating_as_stars(n) == 3.5
      end
    end

    test "it returns 3.0 for any rating above 50 and below 59" do
      for n <- 51..58 do
        assert Helpers.player_rating_as_stars(n) == 3.0
      end
    end

    test "it returns 2.5 for any rating above 42 and below 51" do
      for n <- 43..50 do
        assert Helpers.player_rating_as_stars(n) == 2.5
      end
    end

    test "it returns 2.0 for any rating above 34 and below 43" do
      for n <- 35..42 do
        assert Helpers.player_rating_as_stars(n) == 2.0
      end
    end

    test "it returns 1.5 for any rating above 24 and below 35" do
      for n <- 25..34 do
        assert Helpers.player_rating_as_stars(n) == 1.5
      end
    end

    test "it returns 1.0 for any rating above 20 and below 25" do
      for n <- 21..24 do
        assert Helpers.player_rating_as_stars(n) == 1.0
      end
    end

    test "it returns 0.5 for any rating below 21" do
      assert Helpers.player_rating_as_stars(20) == 0.5
    end
  end
end
