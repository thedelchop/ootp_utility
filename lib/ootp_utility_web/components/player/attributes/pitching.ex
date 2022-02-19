defmodule OOTPUtilityWeb.Components.Player.Attributes.Pitching do
  use Surface.Component

  prop positions, :keyword, required: true
  prop player, :struct, required: true

  def render(assigns) do
    ~F"""
    <div>
      I AM THE PITCHING ATTRIBUTES!
    </div>
    """
  end
end
