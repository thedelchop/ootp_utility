defmodule OOTPUtilityWeb.Components.Player.Attributes.Number do
  use Surface.Component

  prop rating, :integer, required: true

  def render(assigns) do
    ~F"""
    <span class={"text-rating-#{@rating * 2}"}>
      {@rating}
    </span>
    """
  end
end
