defmodule OOTPUtility.UtilitiesTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Utilities

  @positions %{
    "P" => "1",
    "C" => "2",
    "1B" => "3",
    "2B" => "4",
    "3B" => "5",
    "SS" => "6",
    "LF" => "7",
    "CF" => "8",
    "RF" => "9"
  }

  describe "scoring_key_from_position/1" do
    test "returns the correct scoring key for the specified position" do
      for {position, scoring_key} <- @positions do
        assert {:ok, scoring_key} == Utilities.scoring_key_from_position(position)
      end
    end

    test "returns `:error` if a non-recognizable position is passed in" do
      assert Utilities.scoring_key_from_position("QB") == :error
    end
  end

  describe "position_from_scoring_key" do
    test "returns the correct position for the specified scoring key" do
      for {position, scoring_key} <- @positions do
        assert {:ok, position} == Utilities.position_from_scoring_key(scoring_key)
      end
    end

    test "returns `:error` if a non-recognizable position is passed in" do
      assert Utilities.position_from_scoring_key("10") == :error
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
      assert Utilities.position_from_base("mars") == {:error, nil}
    end
  end
end
