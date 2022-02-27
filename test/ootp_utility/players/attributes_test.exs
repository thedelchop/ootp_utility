defmodule OOTPUtility.Players.AttributesTest do
  use OOTPUtility.DataCase, async: true

  import OOTPUtility.Factory

  alias OOTPUtility.Players.{Attribute, Attributes, Player}

  describe "for_player/2" do
    setup do
      player = insert(:player, position: :closer)

      attributes = create_attributes_for_player(player, :pitching, stuff: 155, movement: 100, control: 123)

      {:ok, player: player, attributes: attributes}
    end

    test "it returns the players batting attributes by default if the player is a hitter" do
      player = insert(:player, position: :first_base)

      player_attributes = create_attributes_for_player(player, :batting, [])

      assert_attributes_are_equal(player_attributes, Attributes.for_player(player))
    end

    test "it returns the players pitching attributes by default if the player is a pitcher", %{
      player: player,
      attributes: attributes
    } do
      assert_attributes_are_equal(attributes, Attributes.for_player(player))
    end

    test "it mutates the values of the players attributes to the specified scale if the :scale option is specified",
         %{player: player} do
      player_attributes =
        player
        |> Attributes.for_player(scale: 10)
        |> Enum.filter(&(&1.type == :ability))
        |> Enum.map(fn
          attr ->
            {String.to_atom(attr.name), attr.value}
        end)

      assert player_attributes == [stuff: 8, movement: 5, control: 7]
    end

    test "it only includes attributes with the types specified in the :type option when included",
         %{player: player, attributes: attributes} do
      ability_attributes =
        attributes
        |> Enum.filter(&(&1.type == :ability))
        |> Enum.map(fn
          attr -> attr |> Map.from_struct() |> Map.drop([:player])
        end)

      assert ability_attributes ==
               player
               |> Attributes.for_player(type: :ability)
               |> Enum.map(fn
                 attr -> attr |> Map.from_struct() |> Map.drop([:player])
               end)
    end

    test "it will preload any related records specified with the :preload option", %{
      player: player
    } do
      [attribute | _rest] = Attributes.for_player(player)

      assert %Attribute{player: %Ecto.Association.NotLoaded{}} = attribute

      [attribute | _rest] = Attributes.for_player(player, preload: [:player])

      assert %Attribute{player: %Player{}} = attribute
    end

    test "it returns empty if the player has no ratings" do
      player = insert(:player)

      assert Enum.empty?(Attributes.for_player(player))
    end

    defp assert_attributes_are_equal(expected, actual) do
      assert(
        Enum.map(expected, &attribute_without_player/1) |> Enum.sort() ==
          Enum.map(actual, &attribute_without_player/1) |> Enum.sort()
      )
    end

    defp attribute_without_player(attribute) do
      attribute |> Map.from_struct() |> Map.drop([:player])
    end
  end
end
