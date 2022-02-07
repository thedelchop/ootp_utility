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

  describe "grouped_by_attributes/1" do
    test "it returns a Keyword List, whose keys are the batting attributes, when a Ratings.Batting list is passed in" do
      player = insert(:player)

      insert(:batting_ratings, player: player, type: :ability, contact: 5, gap_power: 5, home_run_power: 5, eye: 5, avoid_strikeouts: 5)
      insert(:batting_ratings, player: player, type: :ability_vs_left, contact: 6, gap_power: 6, home_run_power: 6, eye: 6, avoid_strikeouts: 6)
      insert(:batting_ratings, player: player, type: :ability_vs_right, contact: 4, gap_power: 4, home_run_power: 4, eye: 4, avoid_strikeouts: 4)
      insert(:batting_ratings, player: player, type: :talent, contact: 7, gap_power: 7, home_run_power: 7, eye: 7, avoid_strikeouts: 7)

      assert player |> Ratings.batting_ratings_for() |> Ratings.grouped_by_attributes() == [
        contact: [
          talent: 7,
          ability_vs_right: 4,
          ability_vs_left: 6,
          ability: 5
        ],
        gap_power: [
          talent: 7,
          ability_vs_right: 4,
          ability_vs_left: 6,
          ability: 5
        ],
        home_run_power: [
          talent: 7,
          ability_vs_right: 4,
          ability_vs_left: 6,
          ability: 5
        ],
        eye: [
          talent: 7,
          ability_vs_right: 4,
          ability_vs_left: 6,
          ability: 5
        ],
        avoid_strikeouts: [
          talent: 7,
          ability_vs_right: 4,
          ability_vs_left: 6,
          ability: 5
        ],
      ]
    end

    test "it returns a Keyword List, whose keys are the pitching attributes, when a Ratings.Pitching list is passed in" do
      player = insert(:player)

      insert(:pitching_ratings, player: player, type: :ability, stuff: 5, movement: 5, control: 5)
      insert(:pitching_ratings, player: player, type: :ability_vs_left, stuff: 6, movement: 6, control: 6)
      insert(:pitching_ratings, player: player, type: :ability_vs_right, stuff: 4, movement: 4, control: 4)
      insert(:pitching_ratings, player: player, type: :talent, stuff: 7, movement: 7, control: 7)

      assert player |> Ratings.pitching_ratings_for() |> Ratings.grouped_by_attributes() == [
        stuff: [
          talent: 7,
          ability_vs_right: 4,
          ability_vs_left: 6,
          ability: 5
        ],
        movement: [
          talent: 7,
          ability_vs_right: 4,
          ability_vs_left: 6,
          ability: 5
        ],
        control: [
          talent: 7,
          ability_vs_right: 4,
          ability_vs_left: 6,
          ability: 5
        ]
      ]
    end
  end
end
