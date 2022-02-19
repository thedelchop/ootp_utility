defmodule OOTPUtilityWeb.Components.Player.Attributes.Pitches do
  use Surface.Component

  prop pitches, :keyword, required: true

  def render(assigns) do
    ~F"""
    <div>
      I AM THE PITCHES ATTRIBUTES!
    </div>
    """
  end
end
