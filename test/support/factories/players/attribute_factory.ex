defmodule OOTPUtility.Factories.Players.AttributeFactory do
  alias OOTPUtility.Players
  alias OOTPUtility.Players.Attribute

  import OOTPUtility.Players, only: [is_pitcher: 1]

  import OOTPUtility.Players.Attribute,
    only: [is_batting_attribute: 1, is_pitching_attribute: 1, is_pitch: 1]

  defmacro __using__(_opts) do
    # credo:disable-for-next-line Credo.Check.Refactor.LongQuoteBlocks
    quote do
      def attribute_factory do
        %Attribute{
          name: Enum.random(Attribute.batting_attributes()),
          type: Attribute |> Ecto.Enum.values(:type) |> Enum.random(),
          value: Faker.random_between(0, 200),
          player: build(:player)
        }
      end

      def with_attributes(player, player_attributes \\ Keyword.new())

      def with_attributes(%Players.Player{} = player, player_attributes)
          when is_pitcher(player) do
        with_attributes(player, :pitcher, player_attributes)
      end

      def with_attributes(%Players.Player{} = player, player_attributes) do
        with_attributes(player, :hitter, player_attributes)
      end

      def with_attributes(%Players.Player{} = player, attribute_group, player_attributes) do
        create_attributes_for_player(player, attribute_group, player_attributes)

        player
      end

      def with_pitches(%Players.Player{} = player, pitches) do
        with_attributes(player, :pitches, pitches)
      end

      def with_positions(%Players.Player{} = player, positions_experience) do
        positions_experience
        |> Enum.each(fn
          {position, experience} ->
            insert(:attribute,
              name: Atom.to_string(position),
              type: :ability,
              value: experience,
              player: player
            )
        end)

        player
      end

      def create_attributes_for_player(player, player_attributes \\ Keyword.new())

      def create_attributes_for_player(%Players.Player{} = player, player_attributes)
          when is_pitcher(player) do
        create_attributes_for_player(player, :pitcher, player_attributes)
      end

      def create_attributes_for_player(%Players.Player{} = player, player_attributes) do
        create_attributes_for_player(player, :hitter, player_attributes)
      end

      def create_attributes_for_player(%Players.Player{} = player, :hitter, player_attributes) do
        [:batting, :fielding, :baserunning, :bunting]
        |> Enum.flat_map(&create_attributes_for_player(player, &1, player_attributes))
      end

      def create_attributes_for_player(%Players.Player{} = player, :pitcher, player_attributes) do
        [:pitching, :baserunning, :bunting]
        |> Enum.flat_map(&create_attributes_for_player(player, &1, player_attributes))
      end

      def create_attributes_for_player(
            %Players.Player{} = player,
            attribute_group,
            player_attributes
          ) do
        attribute_group
        |> List.wrap()
        |> build_attributes(player_attributes)
        |> Enum.flat_map(fn
          {attribute_name, types_list} ->
            do_create_attributes_for_player(player, attribute_name, types_list)
        end)
      end

      def do_create_attributes_for_player(
            %Players.Player{} = player,
            attribute_name,
            attributes
          ) do
        attributes
        |> Enum.map(fn
          {type, value} ->
            insert(:attribute,
              player: player,
              name: Atom.to_string(attribute_name),
              type: type,
              value: value
            )
        end)
      end

      defp build_attributes(attribute_groups, player_attributes) do
        attributes = expand_attributes(player_attributes)

        attribute_groups
        |> Enum.flat_map(&do_build_attributes(&1, attributes))
      end

      defp do_build_attributes(:pitches, pitches_attributes), do: pitches_attributes

      defp do_build_attributes(attribute_group, player_attributes) do
        default_attributes_for_group =
          attribute_group
          |> build_default_attributes()

        player_attributes_for_group =
          player_attributes
          |> Enum.filter(fn
            {name, _values} ->
              name in names_for_attribute_group(attribute_group)
          end)

        DeepMerge.deep_merge(default_attributes_for_group, player_attributes_for_group)
      end

      defp build_default_attributes(attribute_group) do
        attribute_group |> names_for_attribute_group() |> do_build_default_attributes()
      end

      def names_for_attribute_group(group_name) when group_name in [:pitches] do
        Attribute
        |> apply(group_name, [])
      end

      def names_for_attribute_group(group_name) do
        attribute_name = String.to_atom("#{group_name}_attributes")

        Attribute
        |> apply(attribute_name, [])
      end

      defp do_build_default_attributes(attribute_names) do
        attribute_names
        |> Enum.map(&{&1, Faker.random_between(20, 200)})
        |> expand_attributes()
      end

      defp types_for(attr) when is_pitch(attr), do: [:ability, :talent]

      defp types_for(attr) when is_batting_attribute(attr) or is_pitching_attribute(attr) do
        [:ability, :ability_vs_left, :ability_vs_right, :talent]
      end

      defp types_for(_), do: [:ability]

      defp expand_attributes(attributes) do
        Enum.map(attributes, fn
          {name, value_or_types_list} ->
            expanded_attrs = do_expand_attributes(name, value_or_types_list)
            {name, expanded_attrs}
        end)
      end

      defp do_expand_attributes(name, value) when is_integer(value) do
        name
        |> Atom.to_string()
        |> types_for()
        |> Enum.map(&{&1, value})
      end

      defp do_expand_attributes(_name, types_list), do: types_list
    end
  end
end
