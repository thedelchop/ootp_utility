defmodule OOTPUtilityWeb.Components.Player.Attributes do
  use Surface.LiveComponent

  alias OOTPUtilityWeb.Components.Player.Attributes.Primary, as: PrimaryAttributes
  alias OOTPUtilityWeb.Components.Player.Attributes.Secondary, as: SecondaryAttributes
  alias OOTPUtilityWeb.Components.Shared.Section
  alias OOTPUtility.Players

  import OOTPUtility.Players, only: [is_pitcher: 1]
  import OOTPUtility.Players.Attribute

  prop player, :struct, required: true

  def render(assigns) do
    ~F"""
      <Section direction={:column} event_target={@myself}>
        <PrimaryAttributes attributes={primary_attributes(@player)} />
        <SecondaryAttributes player={@player} attributes={secondary_attributes(@player)} />
      </Section>
    """
  end

  def handle_event("viewport_resize", _viewport, socket) do
    {:noreply, socket}
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

  defp secondary_attributes(%Players.Player{} = player) when is_pitcher(player) do
    player
    |> attributes()
    |> Keyword.take([:pitches, :baserunning, :bunting, :positions])
  end

  defp secondary_attributes(%Players.Player{} = player) do
    player
    |> attributes()
    |> Keyword.take([:fielding, :positions, :baserunning, :bunting])
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
