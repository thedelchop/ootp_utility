defmodule OOTPUtilityWeb.Components.Shared.Section do
  use Surface.Component

  slot default, required: true

  prop border, :boolean, default: true

  def render(assigns) do
    ~F"""
      <div class={"rounded-2xl", "p-4", "flex", "flex-wrap", "justify-between", "items-center", "bg-white", "overflow-hidden", border: @border}>
        <#slot />
      </div>
    """
  end
end
