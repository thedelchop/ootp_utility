defmodule OOTPUtilityWeb.PlaygroundLive do
  use Surface.LiveView, layout: {OOTPUtilityWeb.LayoutView, "live.html"}

  @impl true
  def render(assigns) do
    ~F"""
      <div></div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
