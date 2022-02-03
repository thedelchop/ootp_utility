defmodule OOTPUtilityWeb.Components.Player.Attributes do
  use Surface.LiveComponent

  alias OOTPUtilityWeb.Components.Shared.{Section, SectionHeader}

  prop player, :struct, required: true

  def render(assigns) do
    ~F"""
      <Section event_target={@myself}>
        <SectionHeader>Player Attributes</SectionHeader>
      </Section>
    """
  end

  def handle_event("viewport_resize", _viewport, socket) do
    {:noreply, socket}
  end
end
