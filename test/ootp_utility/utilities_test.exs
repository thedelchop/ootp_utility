defmodule OOTPUtility.UtilitiesTest do
  use OOTPUtility.DataCase, async: true

  alias OOTPUtility.{Utilities, Players}

  describe "position_from_scoring_key" do
    test "returns the correct position for the specified scoring key" do
      positions = Ecto.Enum.mappings(Players.Player, :position)

      for {position, scoring_key} <- positions do
        assert position == Utilities.position_from_scoring_key(scoring_key)
      end
    end
  end

  describe "position_from_base/1" do
    test "it returns 1B when given first" do
      assert Utilities.position_from_base("first") == {:ok, "1B"}
    end

    test "it returns 1B when given 1st" do
      assert Utilities.position_from_base("1st") == {:ok, "1B"}
    end

    test "it returns 2B when given second" do
      assert Utilities.position_from_base("second") == {:ok, "2B"}
    end

    test "it returns 2B when given 2nd" do
      assert Utilities.position_from_base("2nd") == {:ok, "2B"}
    end

    test "it returns 3B when given third" do
      assert Utilities.position_from_base("third") == {:ok, "3B"}
    end

    test "it returns 3B when given 3rd" do
      assert Utilities.position_from_base("3rd") == {:ok, "3B"}
    end

    test "it returns Home when given home" do
      assert Utilities.position_from_base("home") == {:ok, "Home"}
    end

    test "it returns Home when given HOME" do
      assert Utilities.position_from_base("HOME") == {:ok, "Home"}
    end

    test "it returns an error if the position has no corresponding base" do
      assert Utilities.position_from_base("mars") == :error
    end
  end

  describe "convert_outs_to_innings/1" do
    test "it returns the correct number of innings pitched for the specified outs pitched" do
      assert Utilities.convert_outs_to_innings(0) == 0.0
      assert Utilities.convert_outs_to_innings(3) == 1.0
      assert Utilities.convert_outs_to_innings(4) == 1.3
      assert Utilities.convert_outs_to_innings(5) == 1.6

      assert Utilities.convert_outs_to_innings(550) == 183.3
    end
  end
end
