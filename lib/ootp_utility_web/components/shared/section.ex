defmodule OOTPUtilityWeb.Components.Shared.Section do
  use Surface.Component

  slot default, required: true

  prop border, :boolean, default: true
  prop event_target, :string, required: true

  def render(assigns) do
    ~F"""
      <div phx-hook="WindowResize" phx-target={@event_target} class={"rounded-lg", "md:rounded-2xl", "p-2", "md:p-4", "flex", "flex-wrap", "justify-between", "items-center", "bg-white", "overflow-hidden", border: @border}>
        <#slot />
      </div>
    """
  end
end
