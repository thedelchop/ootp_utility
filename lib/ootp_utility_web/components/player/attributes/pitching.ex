defmodule OOTPUtilityWeb.Components.Player.Attributes.Pitching do
  use Surface.Component

  alias OOTPUtilityWeb.Components.Shared.Table
  alias OOTPUtilityWeb.Components.Shared.Table.Column

  import OOTPUtilityWeb.Helpers, only: [capitalize_all: 1]

  @default_column_classes [
    "p-px",
    "md:p-1",
    "whitespace-nowrap"
  ]

  @default_header_classes [
    "p-1",
    "md:p-2",
    "uppercase",
    "font-small",
    "md:font-medium",
    "text-left"
  ]

  prop positions, :keyword, required: true
  prop player, :struct, required: true

  def render(assigns) do
    ~F"""
      <Table id={"player-pitching-attributes"} data={{name, ratings} <- attributes(@player, @positions)} header_class={&header_class/2} column_class={&column_class/2}>
        <Column label={"Other Pitching Ratings"}>
          {attribute_name(name)}
        </Column>

        <Column label="">
          {as_number(name, Keyword.get(ratings, :ability))}
        </Column>
      </Table>
    """
  end

  defp attribute_name(attribute), do: OOTPUtilityWeb.Helpers.capitalize_all(attribute)

  defp as_number(name, rating) when name in [:velocity, :type] do
    assigns = %{rating: rating}

    ~F"""
      <span>{@rating}</span>
    """
  end

  defp as_number(_name, rating) do
    assigns = %{rating: rating}

    ~F"""
      <span class={"text-rating-#{@rating * 2}"}>{@rating}</span>
    """
  end

  defp header_class(_standing, 0) do
    do_header_class(["text-left"])
  end

  defp header_class(_col, _index),
    do: do_header_class([])

  defp do_header_class(extra_classes) do
    extra_classes ++ @default_header_classes
  end

  defp column_class(_standing, 0) do
    do_column_class(["text-left"])
  end

  defp column_class(_standing, _index) do
    do_column_class([])
  end

  defp do_column_class(extra_classes) do
    Enum.join(extra_classes ++ @default_column_classes, " ")
  end

  defp attributes(player, positions) do
    [
      velocity: [ability: player.velocity],
      stamina: [ability: scale_value(player.stamina, 10)],
      type: [ability: pitcher_type(player.groundball_flyball_ratio)],
      hold_runners: [ability: scale_value(player.hold_runners, 10)],
      defense: Keyword.get(positions, :pitcher, [ability: "-"])
    ]
  end

  defp pitcher_type(:extreme_groundball), do: "Ex. Groundball"
  defp pitcher_type(:extreme_flyball), do: "Ex. Flyball"
  defp pitcher_type(type), do: capitalize_all(type)

  defp scale_value(value, scale) do
    ceil(value * scale / 200.00)
  end
end
