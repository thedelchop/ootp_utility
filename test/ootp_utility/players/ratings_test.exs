defmodule OOTPUtility.Players.RatingsTest do
  use OOTPUtility.DataCase, async: true

  import OOTPUtility.Factory

  alias OOTPUtility.Players.Ratings

  describe "batting_ratings_for/1" do
    test "it returns batting ratings of all types for the specified player" do
      player = insert(:player)

      ratings =
        [:ability, :talent, :ability_vs_left, :ability_vs_right]
        |> Enum.map(&insert(:batting_ratings, player: player, type: &1))

      assert ids_for(ratings) == ids_for(Ratings.batting_ratings_for(player))
    end

    test "it returns empty if the player has no ratings" do
      player = insert(:player)

      assert Enum.empty?(Ratings.batting_ratings_for(player))
    end
  end

  describe "pitching_ratings_for/1" do
    test "it returns batting ratings of all types for the specified player" do
      player = insert(:player)

      ratings =
        [:ability, :talent, :ability_vs_left, :ability_vs_right]
        |> Enum.map(&insert(:pitching_ratings, player: player, type: &1))

      assert ids_for(ratings) == ids_for(Ratings.pitching_ratings_for(player))
    end

    test "it returns empty if the player has no ratings" do
      player = insert(:player)

      assert Enum.empty?(Ratings.pitching_ratings_for(player))
    end
  end
end
