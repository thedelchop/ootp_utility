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

      insert(:batting_ratings, player: player, type: :ability, contact: 50, gap_power: 50, home_run_power: 50, eye: 50, avoid_strikeouts: 50)
      insert(:batting_ratings, player: player, type: :ability_vs_left, contact: 60, gap_power: 60, home_run_power: 60, eye: 60, avoid_strikeouts: 60)
      insert(:batting_ratings, player: player, type: :ability_vs_right, contact: 40, gap_power: 40, home_run_power: 40, eye: 40, avoid_strikeouts: 40)
      insert(:batting_ratings, player: player, type: :talent, contact: 70, gap_power: 70, home_run_power: 70, eye: 70, avoid_strikeouts: 70)

      assert player |> Ratings.batting_ratings_for() |> Ratings.grouped_by_attributes() == [
        contact:          [ talent: 70, ability_vs_right: 40, ability_vs_left: 60, ability: 50 ],
        gap_power:        [ talent: 70, ability_vs_right: 40, ability_vs_left: 60, ability: 50 ],
        home_run_power:   [ talent: 70, ability_vs_right: 40, ability_vs_left: 60, ability: 50 ],
        eye:              [ talent: 70, ability_vs_right: 40, ability_vs_left: 60, ability: 50 ],
        avoid_strikeouts: [ talent: 70, ability_vs_right: 40, ability_vs_left: 60, ability: 50 ],
      ]
    end

    test "it returns a Keyword List, whose keys are the pitching attributes, when a Ratings.Pitching list is passed in" do
      player = insert(:player)

      insert(:pitching_ratings, player: player, type: :ability, stuff: 50, movement: 50, control: 50)
      insert(:pitching_ratings, player: player, type: :ability_vs_left, stuff: 60, movement: 60, control: 60)
      insert(:pitching_ratings, player: player, type: :ability_vs_right, stuff: 40, movement: 40, control: 40)
      insert(:pitching_ratings, player: player, type: :talent, stuff: 70, movement: 70, control: 70)

      assert player |> Ratings.pitching_ratings_for() |> Ratings.grouped_by_attributes() == [
        stuff:    [ talent: 70, ability_vs_right: 40, ability_vs_left: 60, ability: 50 ],
        movement: [ talent: 70, ability_vs_right: 40, ability_vs_left: 60, ability: 50 ],
        control:  [ talent: 70, ability_vs_right: 40, ability_vs_left: 60, ability: 50 ]
      ]
    end
  end

  describe "scale_attributes/2" do
    test "it returns the attributes, whose ratings are adjusted from 1-200 to 1-scale" do

      player = insert(:player)

      insert(:pitching_ratings, player: player, type: :ability,           stuff: 150, movement: 100,  control: 75)
      insert(:pitching_ratings, player: player, type: :ability_vs_left,   stuff: 155, movement: 106,  control: 66)
      insert(:pitching_ratings, player: player, type: :ability_vs_right,  stuff: 147, movement: 94,   control: 84)
      insert(:pitching_ratings, player: player, type: :talent,            stuff: 165, movement: 120,  control: 95)

      scaled_ratings =
        player
        |> Ratings.pitching_ratings_for()
        |> Ratings.grouped_by_attributes()
        |> Ratings.scale_attributes(20)

      assert scaled_ratings == [
        control:  [ ability: 8,  ability_vs_left: 7,  ability_vs_right: 9,  talent: 10  ],
        movement: [ ability: 10, ability_vs_left: 11, ability_vs_right: 10, talent: 12  ],
        stuff:    [ ability: 15, ability_vs_left: 16, ability_vs_right: 15, talent: 17  ]
      ]
    end
  end
end
