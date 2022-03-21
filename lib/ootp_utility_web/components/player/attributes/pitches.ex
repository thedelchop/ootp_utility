defmodule OOTPUtilityWeb.Components.Player.Attributes.Pitches do
  use Surface.Component

  alias OOTPUtilityWeb.Components.Shared.Table
  alias OOTPUtilityWeb.Components.Shared.Table.Column

  @default_column_classes [
    "p-px",
    "md:p-1",
    "whitespace-nowrap",
    "text-center"
  ]

  @default_header_classes [
    "p-1",
    "md:p-2",
    "uppercase",
    "font-small",
    "md:font-medium",
    "text-center"
  ]

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
        {attribute_name(name)}
      </Column>

      <Column label="Ability">
        {as_number(Keyword.get(ratings, :ability))}
      </Column>

      <Column label="Talent">
        {as_number(Keyword.get(ratings, :talent))}
      </Column>
    </Table>
    """
  end

  def attribute_name(attribute) do
    OOTPUtilityWeb.Helpers.capitalize_all(attribute)
  end

  def as_number(rating) do
    assigns = %{rating: rating}

    ~F"""
    <span class={"text-rating-#{@rating * 2}"}>{@rating}</span>
    """
  end

  def header_class(_standing, 0) do
    do_header_class(["text-left"])
  end

  def header_class(_col, _index),
    do: do_header_class([])

  def do_header_class(extra_classes \\ []) do
    extra_classes ++ @default_header_classes
  end

  def column_class(_standing, 0) do
    do_column_class(["text-left"])
  end

  def column_class(_standing, _index) do
    do_column_class([])
  end

  defp do_column_class(extra_classes) do
    Enum.join(extra_classes ++ @default_column_classes, " ")
  end
end
