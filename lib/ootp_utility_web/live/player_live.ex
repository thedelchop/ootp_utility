defmodule OOTPUtilityWeb.PlayerLive do
  use Surface.LiveView

  alias Surface.Components.LiveRedirect

  alias OOTPUtilityWeb.TeamLive
  alias OOTPUtilityWeb.Router.Helpers, as: Routes
  alias OOTPUtilityWeb.Components.Player.{Details,Rating}
  alias OOTPUtilityWeb.Components.Shared.Section

  import OOTPUtilityWeb.Helpers, only: [display_size: 1]
  import OOTPUtility.Utilities, only: [position_name_to_position_key: 0]

  alias OOTPUtility.Players

  @impl true
  def render(assigns) do
    ~F"""
      <Section event_target={@myself}>
        <div class="flex gap-1 md:gap-2">
          <img class="h-16 w-16 md:h-28 md:w-28 rounded-full md:mt-2" src={Routes.static_path(@socket, "/images/default_player_photo.jpg")} alt="">
          <div class="flex flex-wrap items-center md:divide-x gap-2 md:gap-4">
            <div class="flex flex-col gap-1 md:gap-2">
              <h1 class="text-2xl md:text-4xl font-medium text-gray-900">{name(@player, @size)}</h1>
              <div class="flex flex-row items-center gap-1 md:gap-2 text-base md:text-lg font-medium text-gray-900">
                <LiveRedirect to={path_to_team(@team, @socket)} class="contents">
                    <div class="flex-shrink-0 h-6 md:h-8 h-6 md:w-8">
                      <img class="h-6 md:h-8 w-6 md:w-8 rounded-full" src={Routes.static_path(@socket, "/images/logos/#{@team.logo_filename}")} alt="">
                    </div>
                    <div class="block sm:hidden">{@team.abbr}</div>
                    <div class="hidden sm:block">{@team.name}</div>
                </LiveRedirect>
                <div>{"##{@player.uniform_number}"}</div>
                <div>{"#{position(@player)}"}</div>
              </div>
            </div>
            <Details player={@player} />
          </div>
        </div>
        <Rating player={@player} class="m-auto md:m-0" />
      </Section>
    """
  end

  def name(%Players.Player{} = player, size) when size in [:xsmall, :small] do
    Players.name(player, :short)
  end

  def name(%Players.Player{} = player, _size), do: Players.name(player, :full)

  def position(%Players.Player{position: position} = _player), do: Map.get(position_name_to_position_key(), position)

  def path_to_team(
        %{
          slug: slug
        } = _team,
        socket
      ) do
    Routes.live_path(socket, TeamLive, slug)
  end

  @impl true
  def handle_event("viewport_resize", viewport, socket) do
    {:noreply, assign(socket, :size, display_size(viewport))}
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    player = Players.get_player_by_slug(slug)

    {
      :ok,
      socket
      |> assign(:player, player)
      |> assign(:team, player.team)
      |> assign(:size, :medium)
    }
  end
end
