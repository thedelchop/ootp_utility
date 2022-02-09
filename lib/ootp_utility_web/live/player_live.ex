defmodule OOTPUtilityWeb.PlayerLive do
  use Surface.LiveView

  alias OOTPUtility.Players

  alias OOTPUtilityWeb.Components.Player.{Attributes, Header}

  @impl true
  def render(assigns) do
    ~F"""
      <div class="flex flex-col gap-4">
        <Header id={"#{@player.slug}-header"} player={@player} />
        <Attributes id={"#{@player.slug}-attributes"} player={@player} />
      </div>
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
