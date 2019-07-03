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

  describe "scoring_key_from_position" do
    test "returns the correct scoring key for the specified position" do
      for {position, scoring_key} <- @positions do
        assert {:ok, scoring_key } == Utilities.scoring_key_from_position(position)
      end
    end

    test "returns `:error` if a non-recognizable position is passed in" do
      assert Utilities.scoring_key_from_position("QB") == :error
    end
  end

  describe "position_from_scoring_key" do
    test "returns the correct position for the specified scoring key" do
      for {position, scoring_key} <- @positions do
        assert {:ok, position } == Utilities.position_from_scoring_key(scoring_key)
      end
    end

    test "returns `:error` if a non-recognizable position is passed in" do
      assert Utilities.position_from_scoring_key("10") == :error
    end
  end
end
