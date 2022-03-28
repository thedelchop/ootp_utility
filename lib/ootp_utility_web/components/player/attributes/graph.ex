defmodule OOTPUtilityWeb.Components.Player.Attributes.Graph do
  use Surface.Component

  prop rating, :integer, required: true

  def render(assigns) do
    ~F"""
    <div class={
      "bg-rating-#{@rating * 2}",
      "w-#{@rating * 2}/20",
      "pl-2",
      "text-large",
      "text-gray-700",
      "text-left",
      "drop-shadow-lg rounded-sm"
    }>{@rating}</div>
    """
  end
end
