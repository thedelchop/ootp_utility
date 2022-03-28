defmodule OOTPUtilityWeb.Components.Player.Attributes.RunningBunting do
  use Surface.Component

  alias OOTPUtilityWeb.Components.Shared.Table
  alias OOTPUtilityWeb.Components.Shared.Table.Column

  alias OOTPUtilityWeb.Components.Player.Attributes.Number

  import OOTPUtilityWeb.Components.Player.Attributes.Helpers

  prop running_attributes, :keyword, required: true
  prop bunting_attributes, :keyword, required: true

  def render(assigns) do
    ~F"""
    <Table
      id="player-running-bunting-attributes"
      data={{name, ratings} <- @bunting_attributes ++ @running_attributes}
      header_class={&header_class/2}
      column_class={&column_class/2}
    >
      <Column label="Run/Bunt">
        {attribute_name(name)}
      </Column>

      <Column label="">
        <Number rating={Keyword.get(ratings, :ability)} />
      </Column>
    </Table>
    """
  end
end
