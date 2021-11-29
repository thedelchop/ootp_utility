defmodule OOTPUtilityWeb.HelpersTest do
  use ExUnit.Case, async: true

  alias OOTPUtilityWeb.Helpers

  describe "friendly_date/1" do
    test "it formats the specified date as MM/DD/YYYY" do
      date = Date.new!(2021, 09, 12)

      assert Helpers.friendly_date(date) == "09/12/2021"
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
end
