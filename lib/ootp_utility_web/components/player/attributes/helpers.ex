defmodule OOTPUtilityWeb.Components.Player.Attributes.Helpers do
  def attribute_name(attribute), do: OOTPUtilityWeb.Helpers.capitalize_all(attribute)

  @default_header_classes [
    "p-1",
    "md:p-2",
    "uppercase",
    "font-small",
    "md:font-medium",
    "text-left"
  ]

  def header_class(_col, _index), do: header_class([])

  def header_class(extra_classes \\ []) do
    extra_classes ++ @default_header_classes
  end

  @default_column_classes [
    "p-px",
    "md:p-1",
    "whitespace-nowrap"
  ]

  def column_class(_standing, 0) do
    do_column_class(["text-left"])
  end

  def column_class(_standing, _index) do
    do_column_class([])
  end

  defp do_column_class(extra_classes) do
    extra_classes ++ @default_column_classes
  end
end
