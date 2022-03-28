defmodule OOTPUtilityWeb.Components.Player.Attributes.Primary do
  use Surface.Component

  alias OOTPUtilityWeb.Components.Shared.Table
  alias OOTPUtilityWeb.Components.Shared.Table.Column
  alias OOTPUtilityWeb.Components.Player.Attributes.{Graph, Helpers}

  prop attributes, :keyword, required: true
  prop title, :string, default: ""

  def render(assigns) do
    ~F"""
    <Table
      id="primary-player-attributes"
      data={{name, ratings} <- @attributes}
      header_class={&header_class/2}
      column_class={&column_class/2}
    >
      <Column label={@title}>
        {attribute_name(name)}
      </Column>

      <Column label="Ability">
        <Graph rating={Keyword.get(ratings, :ability)} />
      </Column>

      <Column label="Vs Left">
        <Graph rating={Keyword.get(ratings, :ability_vs_left)} />
      </Column>

      <Column label="Vs Right">
        <Graph rating={Keyword.get(ratings, :ability_vs_right)} />
      </Column>

      <Column label="Talent">
        <Graph rating={Keyword.get(ratings, :talent)} />
      </Column>
    </Table>
    """
  end

  def attribute_name(attribute) do
    Map.get(
      %{
        gap_power: "Gap",
        home_run_power: "Power",
        avoid_strikeouts: "Avoid Ks"
      },
      attribute,
      Helpers.attribute_name(attribute)
    )
  end

  def header_class(attribute, index) when index in [2, 3] do
    Helpers.header_class(attribute, index) ++ ["hidden", "md:table-cell"]
  end

  def header_class(attr, index), do: Helpers.header_class(attr, index)

  def column_class(attribute, index) when index in [2, 3] do
    Helpers.column_class(attribute, index) ++ ["hidden", "md:table-cell"]
  end

  def column_class(attr, index), do: Helpers.column_class(attr, index)
end
