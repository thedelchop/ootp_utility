defmodule OOTPUtilityWeb.PlayerLive do
  use Surface.LiveView

  alias OOTPUtility.Players

  alias OOTPUtilityWeb.Components.Player.{Attributes, Header}

  import OOTPUtility.Players, only: [is_pitcher: 1]

  @impl true
  def render(assigns) do
    ~F"""
      <div class="flex flex-col gap-4">
        <Header id={"#{@player.slug}-header"} player={@player} />
        <Attributes id={"#{@player.slug}-attributes"} attributes={@attributes} />
      </div>
    """
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    player = Players.get_player_by_slug(slug)

    attributes = get_attributes(player)

    {
      :ok,
      socket
      |> assign(:player, player)
      |> assign(:attributes, attributes)
    }
  end

  defp get_attributes(%Players.Player{} = player) when is_pitcher(player) do
    player
    |> Players.Ratings.pitching_ratings_for()
    |> Players.Ratings.grouped_by_attributes()
  end

  defp get_attributes(%Players.Player{} = player) do
    player
    |> Players.Ratings.batting_ratings_for()
    |> Players.Ratings.grouped_by_attributes()
  end
end
