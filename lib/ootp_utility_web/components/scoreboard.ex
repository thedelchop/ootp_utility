defmodule OOTPUtilityWeb.Components.Scoreboard do
  use Surface.LiveComponent

  alias __MODULE__
  alias OOTPUtility.Games
  alias OOTPUtilityWeb.Components.Scoreboard.{EmptyGame, Game}

  @sm_min_width 640
  @md_min_width 768
  @lg_min_width 1024
  @xl_min_width 1280

  prop subject, :struct, required: true
  prop date, :date, required: true

  data size, :number, default: nil
  data games, :list, default: []

  def render(assigns) do
    ~F"""
      <div class="flex overflow-hidden justify-between rounded-md" :hook="WindowResize" id="scoreboard" phx-target={@myself}>
        <div class={pagination_css_class("rounded-l-md")} :on-click="decrement_date" phx-target={@myself}>
          <Heroicons.Surface.Icon name="chevron-left" type="solid" class="h-6 w-6" />
        </div>
        {#if Enum.empty?(@games)}
          {#for _n <- 1..8}
            <EmptyGame />
          {/for}
        {#else}
          {#for game <- @games}
            <Game id={game.id} game={game} />
          {/for}
        {/if}
        <div class={pagination_css_class("rounded-r-md")} :on-click="increment_date">
          <Heroicons.Surface.Icon name="chevron-right" type="solid" class="h-6 w-6" />
        </div>
      </div>
    """
  end

  def handle_event("decrement_date", _, socket) do
    date = Timex.subtract(socket.assigns.date, Timex.Duration.from_days(1))

    send_update(Scoreboard,
      id: "boston-red-sox-scoreboard",
      date: date
    )

    {:noreply, socket}
  end

  def handle_event("increment_date", _, socket) do
    date = Timex.add(socket.assigns.date, Timex.Duration.from_days(1))

    send_update(Scoreboard,
      id: "boston-red-sox-scoreboard",
      date: date
    )

    {:noreply, socket}
  end

  def handle_event("viewport_resize", viewport, socket) do
    width = Map.get(viewport, "width")

    size =
      case display_size(width) do
        :xsmall -> 2
        :small -> 4
        :medium -> 5
        :large -> 6
        _ -> 8
      end

    games = Games.for_team(socket.assigns.subject, limit: size, start_date: socket.assigns.date)

    send_update(Scoreboard,
      id: "boston-red-sox-scoreboard",
      games: games
    )

    {:noreply, socket}
  end

  defp pagination_css_class(extra) when is_binary(extra) do
    pagination_css_class([extra])
  end

  defp pagination_css_class(extra) do
    [
      "inline-flex",
      "items-center",
      "p-2",
      "cursor-pointer",
      "border",
      "border-gray-200",
      "bg-white",
      "text-sm",
      "font-medium",
      "text-gray-500",
      "hover:bg-gray-200",
      "shadow"
    ] ++ extra
  end

  defp display_size(width) when width < @sm_min_width, do: :xsmall
  defp display_size(width) when width < @md_min_width, do: :small
  defp display_size(width) when width < @lg_min_width, do: :medium
  defp display_size(width) when width < @xl_min_width, do: :large
  defp display_size(_width), do: :xlarge
end
