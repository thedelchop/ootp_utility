defmodule OOTPUtilityWeb.PlayerLive do
  use Surface.LiveView

  @impl true
  def render(assigns) do
    ~F"""
      <p> I am a player </p>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
