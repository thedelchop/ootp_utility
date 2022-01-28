defmodule OOTPUtilityWeb.Components.Shared.Section do
  use Surface.Component

  slot default, required: true

  prop direction, :atom, values: [:row, :column], default: :row
  prop border, :boolean, default: true
  prop wrap, :boolean, default: true
  prop event_target, :string, required: true

  def render(assigns) do
    ~F"""
      <div phx-hook="WindowResize" phx-target={@event_target} class={css_classes(@border, @wrap, @direction)}>
        <#slot />
      </div>
    """
  end

  def css_classes(border, wrap, :column) do
    do_css_classes(border, wrap) ++ ["flex-col", "justify-between"]
  end

  def css_classes(border, wrap, :row) do
    do_css_classes(border, wrap) ++ ["justify-between", "items-center"]
  end

  def css_classes(border, wrap, _), do: do_css_classes(border, wrap)

  def do_css_classes(border, wrap) do
    [
      "rounded-lg",
      "md:rounded-2xl",
      "p-2",
      "md:p-4",
      "flex",
      "bg-white",
      "overflow-hidden",
      "flex-wrap": wrap,
      border: border
    ]
  end
end
