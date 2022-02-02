defmodule OOTPUtilityWeb.PlayerLive do
  use Surface.LiveView

  alias OOTPUtility.Players

  alias OOTPUtilityWeb.Components.Player.Header

  @impl true
  def render(assigns) do
    ~F"""
      <Header id={"#{@player.slug}-header"} player={@player} />
    """
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    player = Players.get_player_by_slug(slug)

    {
      :ok,
      socket
      |> assign(:player, player)
    }
  end
end
