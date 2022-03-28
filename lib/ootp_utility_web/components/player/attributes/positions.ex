defmodule OOTPUtilityWeb.Components.Player.Attributes.Positions do
  use Surface.Component

  alias OOTPUtilityWeb.Components.Shared.Table
  alias OOTPUtilityWeb.Components.Shared.Table.Column

  alias OOTPUtilityWeb.Components.Player.Attributes.Number

  import OOTPUtilityWeb.Components.Player.Attributes.Helpers

  prop attributes, :keyword, required: true

  def render(assigns) do
    ~F"""
    <Table
      id="player-position-experience"
      data={{name, ratings} <- @attributes}
      header_class={&header_class/2}
      column_class={&column_class/2}
    >
      <Column label="Position Ratings">
        {attribute_name(name)}
      </Column>

      <Column label="">
        {#if is_nil(Keyword.get(ratings, :ability))}
          <span>-</span>
        {#else}
          <Number rating={Keyword.get(ratings, :ability)} />
        {/if}
      </Column>
    </Table>
    """
  end
end
