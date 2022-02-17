defmodule OOTPUtility.Factories.Players.AttributeFactory do
  alias OOTPUtility.Players
  alias OOTPUtility.Players.Attribute

  import OOTPUtility.Players.Attribute, only: [batting_attributes: 0, pitching_attributes: 0]

  defmacro __using__(_opts) do
    quote do
      def attribute_factory do
        %Attribute{
          name: Enum.random(Attribute.batting_attributes()),
          type: Attribute |> Ecto.Enum.values(:type) |> Enum.random(),
          value: Faker.random_between(0, 200),
          player: build(:player)
        }
      end

      def with_attributes(%Players.Player{} = player, attributes_and_ratings) do
        for {attribute_name, value} <- attributes_and_ratings do
          Attribute
          |> Ecto.Enum.values(:type)
          |> Enum.each(
            &insert(:attribute,
              type: &1,
              name: Atom.to_string(attribute_name),
              value: value,
              player: player
            )
          )
        end

        player
      end

      def create_attributes_for_player(
            player \\ build(:player),
            batting_or_pitching,
            types \\ Ecto.Enum.values(Attribute, :type)
          )

      def create_attributes_for_player(player, :batting, types) do
        batting_attributes()
        |> Enum.map(&Atom.to_string/1)
        |> do_create_attributes_for_player(player, types)
      end

      def create_attributes_for_player(player, :pitching, types) do
        pitching_attributes()
        |> Enum.map(&Atom.to_string/1)
        |> do_create_attributes_for_player(player, types)
      end

      defp do_create_attributes_for_player(
             attribute_names,
             %Players.Player{} = player,
             types \\ Ecto.Enum.values(Attribute, :type)
           ) do
        Enum.flat_map(attribute_names, &create_attribute_for_types(player, &1, types))
      end

      defp create_attribute_for_types(player, name) do
        types = Ecto.Enum.values(Attribute, :type)

        create_attribute_for_types(player, name, types)
      end

      defp create_attribute_for_types(player, name, types) do
        Enum.map(types, &insert(:attribute, player: player, name: name, type: &1))
      end
    end
  end
end
