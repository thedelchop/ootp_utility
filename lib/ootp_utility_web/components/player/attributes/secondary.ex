defmodule OOTPUtilityWeb.Components.Player.Attributes.Secondary do
  use Surface.Component

  alias OOTPUtilityWeb.Components.Player.Attributes.Fielding, as: FieldingAttributes
  alias OOTPUtilityWeb.Components.Player.Attributes.Pitching, as: PitchingAttributes
  alias OOTPUtilityWeb.Components.Player.Attributes.{Pitches, Positions}
  alias OOTPUtilityWeb.Components.Player.Attributes.RunningBunting, as: RunningBuntingAttributes

  import OOTPUtility.Players, only: [is_pitcher: 1]

  prop attributes, :keyword, required: true
  prop player, :struct, required: true

  def render(%{player: player} = assigns) when is_pitcher(player) do
    ~F"""
    <div class={container_classes()}>
      <Pitches pitches={attributes_for(@attributes, :pitches)} />
      <PitchingAttributes player={@player} positions={attributes_for(@attributes, :positions)} />
      <RunningBuntingAttributes running_attributes={attributes_for(@attributes, :baserunning)} bunting_attributes={attributes_for(@attributes, :bunting)} />
    </div>
    """
  end

  def render(assigns) do
    ~F"""
    <div class={container_classes()}>
      <FieldingAttributes attributes={attributes_for(@attributes, :fielding)} />
      <Positions attributes={attributes_for(@attributes, :positions)} />
      <RunningBuntingAttributes running_attributes={attributes_for(@attributes, :baserunning)} bunting_attributes={attributes_for(@attributes, :bunting)} />
    </div>
    """
  end

  defp attributes_for(attributes, type) do
    Keyword.get(attributes, type)
  end

  defp container_classes, do: ["flex", "gap-4", "justify-center"]
end
