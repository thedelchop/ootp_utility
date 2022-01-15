defmodule OOTPUtilityWeb.PlayerLive do
  use Surface.LiveView

  alias OOTPUtilityWeb.Components.Team.NameWithLogo, as: TeamNameWithLogo
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  import OOTPUtilityWeb.Helpers, only: [capitalize_all: 1]

  alias OOTPUtility.Players

  @impl true
  def render(assigns) do
    ~F"""
      <div class="border rounded-2xl sm:p-6 lg:p-8 flex justify-between bg-white">
        <div class="flex space-x-4">
          <img class="h-28 w-28 rounded-full" src={Routes.static_path(@socket, "/images/default_player_photo.png")} alt="">
          <div class="flex divide-x-1 space-x-4">
            <div class="flex flex-col space-y-4">
              <h1 class="text-4xl font-medium text-gray-900">{name(@player)}</h1>
              <div class="flex flex-row items-center space-x-3 text-lg font-medium text-gray-900">
                <TeamNameWithLogo id={"#{@player.slug}-team-header"} team={@player.team} class={"text-lg"} />
                <h2>{"##{@player.uniform_number}"}</h2>
                <h2>{"#{position(@player)}"}</h2>
              </div>
            </div>
            <dl>
              <div class="sm:grid sm:grid-cols-3 sm:gap-1 p-1">
                <dt class="text-sm font-medium text-gray-500">
                  HT/WT:
                </dt>
                <dd class="text-sm tracking-wider text-gray-900 sm:col-span-2">
                  {@player.height}/{@player.weight}
                </dd>
              </div>
              <div class="sm:grid sm:grid-cols-3 sm:gap-1 p-1">
                <dt class="text-sm font-medium text-gray-500">
                  DOB:
                </dt>
                <dd class="text-sm tracking-wider text-gray-900 sm:col-span-2">
                  {Timex.format!(@player.date_of_birth, "{0M}/{0D}/{YYYY}")} ({@player.age})
                </dd>
              </div>
              <div class="sm:grid sm:grid-cols-3 sm:gap-1 p-1">
                <dt class="text-sm tracking-wider font-medium text-gray-500">
                  B/T
                </dt>
                <dd class="text-sm tracking-wider text-gray-900 sm:col-span-2">
                  {String.capitalize(@player.bats)}/{String.capitalize(@player.throws)}
                </dd>
              </div>
            </dl>
          </div>
        </div>
      </div>
    """
  end

  def name(%Players.Player{} = player), do: Players.name(player, :full)

  def position(%Players.Player{position: position} = _player), do: capitalize_all(position)

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    player = Players.get_player_by_slug(slug)

    {:ok, assign(socket, :player, player)}
  end
end
