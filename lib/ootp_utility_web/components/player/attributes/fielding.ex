defmodule OOTPUtilityWeb.Components.Player.Attributes.Fielding do
  use Surface.Component

  alias OOTPUtilityWeb.Components.Shared.Table
  alias OOTPUtilityWeb.Components.Shared.Table.Column
  alias OOTPUtilityWeb.Components.Player.Attributes.Number

  import OOTPUtilityWeb.Components.Player.Attributes.Helpers

  prop attributes, :keyword, required: true

  def render(assigns) do
    ~F"""
    <Table
      id="player-fielding-attributes"
      data={{name, ratings} <- @attributes}
      header_class={&header_class/2}
      column_class={&column_class/2}
    >
      <Column label="Fielding Ratings">
        {attribute_name(name)}
      </Column>

      <Column label="">
        <Number rating={Keyword.get(ratings, :ability)} />
      </Column>
    </Table>
    """
  end
end
