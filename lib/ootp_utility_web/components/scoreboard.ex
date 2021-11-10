defmodule OOTPUtilityWeb.Components.Scoreboard do
  use Surface.Component

  alias OOTPUtilityWeb.Components.Scoreboard.Game

  @sm_max_width 768
  @md_max_width 1080

  prop games, :list, required: true
  prop size, :number, default: 6

  def render(assigns) do
    ~F"""
      <div class="flex bg-gray-200 p-5 justify-evenly rounded-md">
        {#for game <- Enum.take(@games, @size)}
          <Game id={game.id} game={game} />
        {/for}
      </div>
    """
  end

  def handle_event("viewport_resize", %{"width" => width}, socket) do
    socket =
      socket
      |> assign(
        :size,
        case display_size(width) do
          :small -> 2
          :medium -> 6
          _ -> 8
        end
      )

    {:no_reply, socket}
  end

  defp display_size(width) when width <= @sm_max_width, do: :small
  defp display_size(width) when width <= @md_max_width, do: :medium
  defp display_size(_width), do: :large
end
