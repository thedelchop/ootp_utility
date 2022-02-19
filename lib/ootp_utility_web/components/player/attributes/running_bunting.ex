defmodule OOTPUtilityWeb.Components.Player.Attributes.RunningBunting do
  use Surface.Component

  prop running_attributes, :keyword, required: true
  prop bunting_attributes, :keyword, required: true

  def render(assigns) do
    ~F"""
    <div>
      I AM RUNNING BUNTING ATTRIBUTES!
    </div>
    """
  end
end
