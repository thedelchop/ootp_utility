defmodule OOTPUtilityWeb.Components.Player.Attributes.Positions do
  use Surface.Component

  prop attributes, :keyword, required: true

  def render(assigns) do
    ~F"""
    <div>
      I AM POSITIONS RATINGS!
    </div>
    """
  end
end
