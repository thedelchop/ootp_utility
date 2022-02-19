defmodule OOTPUtilityWeb.Components.Player.Attributes.Fielding do
  use Surface.Component

  prop attributes, :keyword, required: true

  def render(assigns) do
    ~F"""
    <div>
      I AM FIELDING ATTRIBUTES!
    </div>
    """
  end
end
