defmodule OOTPUtilityWeb.Components.Player.Attributes do
  use Surface.LiveComponent

  alias OOTPUtilityWeb.Components.Player.Attributes.Primary, as: PrimaryAttributes
  alias OOTPUtilityWeb.Components.Player.Attributes.Fielding, as: FieldingAttributes
  alias OOTPUtilityWeb.Components.Player.Attributes.Pitching, as: PitchingAttributes
  alias OOTPUtilityWeb.Components.Player.Attributes.RunningBunting, as: RunningBuntingAttributes

  alias OOTPUtilityWeb.Components.Player.Attributes.{Pitches, Positions}

  alias OOTPUtilityWeb.Components.Shared.Section
  alias OOTPUtility.Players

  import OOTPUtility.Players, only: [is_pitcher: 1]
  import OOTPUtility.Players.Attribute

  prop player, :struct, required: true

  def render(assigns) do
    ~F"""
    <Section direction={:column} event_target={@myself}>
      <PrimaryAttributes
        title={primary_attributes_title(@player)}
        attributes={primary_attributes(@player)}
      />
      <div class="flex gap-8 flex-wrap">
        {#if is_pitcher(@player)}
          <div class="grow"><Pitches pitches={attributes_for(@player, :pitches)} /></div>
          <div class="grow"><PitchingAttributes player={@player} positions={attributes_for(@player, :positions)} /></div>
          <div class="grow"><RunningBuntingAttributes
              running_attributes={attributes_for(@player, :baserunning)}
              bunting_attributes={attributes_for(@player, :bunting)}
            /></div>
        {#else}
          <div class="grow"><FieldingAttributes attributes={attributes_for(@player, :fielding)} /></div>
          <div class="grow"><Positions attributes={attributes_for(@player, :positions)} /></div>
          <div class="grow"><RunningBuntingAttributes
              running_attributes={attributes_for(@player, :baserunning)}
              bunting_attributes={attributes_for(@player, :bunting)}
            /></div>
        {/if}
      </div>
    </Section>
    """
  end

  def handle_event("viewport_resize", _viewport, socket) do
    {:noreply, socket}
  end

  defp primary_attributes_title(%Players.Player{} = player) do
    if is_pitcher(player), do: "Pitching Ratings", else: "Batting Ratings"
  end

  defp primary_attributes(%Players.Player{} = player) when is_pitcher(player) do
    player
    |> attributes()
    |> Keyword.get(:pitching)
  end

  defp primary_attributes(%Players.Player{} = player) do
    player
    |> attributes()
    |> Keyword.get(:batting)
  end

  defp attributes_for(%Players.Player{} = player, :positions) do
    positions_placeholder =
      Players.Player
      |> Ecto.Enum.values(:position)
      |> Enum.reject(fn
        pos when pos in [:starting_pitcher, :middle_reliever, :closer, :designated_hitter] -> true
        _ -> false
      end)
      |> Enum.map(&{&1, [ability: nil]})

    player
    |> do_attributes_for(:positions)
    |> Keyword.merge(positions_placeholder, fn
      _key, position_rating, _v2 ->
        position_rating
    end)
  end

  defp attributes_for(%Players.Player{} = player, :pitches) do
    player
    |> attributes()
    |> Keyword.get(:pitches)
  end

  defp attributes_for(%Players.Player{} = player, type) do
    do_attributes_for(player, type)
  end

  defp do_attributes_for(%Players.Player{} = player, type) do
    player
    |> attributes()
    |> Keyword.get(type)
  end

  defp attributes(%Players.Player{} = player) when is_pitcher(player) do
    do_attributes(player, [:pitching, :pitches, :positions, :baserunning, :bunting])
  end

  defp attributes(%Players.Player{} = player) do
    do_attributes(player, [:batting, :baserunning, :fielding, :positions, :bunting])
  end

  defp do_attributes(%Players.Player{} = player, includes) do
    Players.attributes_for(player, scale: 10, include: includes)
    |> Enum.map(&Map.from_struct/1)
    |> Enum.group_by(&attribute_group/1)
    |> Enum.map(fn
      {attr_name, attrs} ->
        {
          attr_name,
          attrs
          |> Enum.group_by(& &1.name)
          |> Enum.map(fn
            {attr_name, attrs} ->
              {
                String.to_atom(attr_name),
                Enum.map(attrs, fn attr -> {attr.type, attr.value} end)
              }
          end)
        }
    end)
    |> Enum.map(fn
      {attr_name, attrs} ->
        ordered_attrs =
          attr_name
          |> order_of_attributes()
          |> Enum.reduce([], &[{&1, Keyword.get(attrs, &1, [])} | &2])
          |> Enum.filter(fn
            {_name, ratings} -> not Enum.empty?(ratings)
          end)
          |> Enum.reverse()

        {attr_name, ordered_attrs}
    end)
  end

  defp order_of_attributes(attribute_group) do
    cond do
      attribute_group == :positions ->
        positions()

      attribute_group == :pitches ->
        pitches()

      true ->
        apply(Players.Attribute, String.to_atom("#{attribute_group}_attributes"), [])
    end
  end

  defp attribute_group(%{name: name}) do
    cond do
      is_batting_attribute(name) -> :batting
      is_pitching_attribute(name) -> :pitching
      is_fielding_attribute(name) -> :fielding
      is_baserunning_attribute(name) -> :baserunning
      is_bunting_attribute(name) -> :bunting
      is_position(name) -> :positions
      is_pitch(name) -> :pitches
    end
  end
end
