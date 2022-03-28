defmodule OOTPUtilityWeb.Components.Player.Attributes.Pitching do
  use Surface.Component

  alias OOTPUtilityWeb.Components.Shared.Table
  alias OOTPUtilityWeb.Components.Shared.Table.Column

  alias OOTPUtilityWeb.Components.Player.Attributes.Number

  import OOTPUtilityWeb.Components.Player.Attributes.Helpers
  import OOTPUtilityWeb.Helpers, only: [capitalize_all: 1]

  prop positions, :keyword, required: true
  prop player, :struct, required: true

  def render(assigns) do
    ~F"""
    <Table
      id="player-pitching-attributes"
      data={{name, ratings} <- attributes(@player, @positions)}
      header_class={&header_class/2}
      column_class={&column_class/2}
    >
      <Column label="Other Pitching Ratings">
        {attribute_name(name)}
      </Column>

      <Column label="">
        {#if name in [:velocity, :type]}
          <span>{Keyword.get(ratings, :ability)}</span>
        {#else}
          <Number rating={Keyword.get(ratings, :ability)} />
        {/if}
      </Column>
    </Table>
    """
  end

  defp attributes(player, positions) do
    [
      velocity: [ability: player.velocity],
      stamina: [ability: scale_value(player.stamina, 10)],
      type: [ability: pitcher_type(player.groundball_flyball_ratio)],
      hold_runners: [ability: scale_value(player.hold_runners, 10)],
      defense: Keyword.get(positions, :pitcher, ability: "-")
    ]
  end

  defp pitcher_type(:extreme_groundball), do: "Ex. Groundball"
  defp pitcher_type(:extreme_flyball), do: "Ex. Flyball"
  defp pitcher_type(type), do: capitalize_all(type)

  defp scale_value(value, scale) do
    ceil(value * scale / 200.00)
  end
end
