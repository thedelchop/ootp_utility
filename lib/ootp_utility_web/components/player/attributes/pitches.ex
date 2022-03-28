defmodule OOTPUtilityWeb.Components.Player.Attributes.Pitches do
  use Surface.Component

  alias OOTPUtilityWeb.Components.Shared.Table
  alias OOTPUtilityWeb.Components.Shared.Table.Column

  alias OOTPUtilityWeb.Components.Player.Attributes.{Helpers, Number}

  prop pitches, :keyword, required: true

  def render(assigns) do
    ~F"""
    <Table
      id="player-pitch-ratings"
      data={{name, ratings} <- @pitches}
      header_class={&header_class/2}
      column_class={&column_class/2}
    >
      <Column label="Pitches">
        {Helpers.attribute_name(name)}
      </Column>

      <Column label="Ability">
        <Number rating={Keyword.get(ratings, :ability)} />
      </Column>

      <Column label="Talent">
        <Number rating={Keyword.get(ratings, :talent)} />
      </Column>
    </Table>
    """
  end

  def header_class(col, 0), do: Helpers.header_class(col, 0) ++ ["text-left"]

  def header_class(col, index), do: Helpers.header_class(col, index) ++ ["text-center"]

  def column_class(col, 0), do: Helpers.column_class(col, 0) ++ ["text-left"]

  def column_class(col, index), do: Helpers.column_class(col, index) ++ ["text-center"]
end
