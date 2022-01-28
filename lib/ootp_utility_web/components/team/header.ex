defmodule OOTPUtilityWeb.Components.Team.Header do
  use Surface.LiveComponent

  alias OOTPUtility.Teams
  alias OOTPUtilityWeb.Components.Team.Rankings
  alias OOTPUtilityWeb.Router.Helpers, as: Routes
  alias OOTPUtilityWeb.Components.Shared.Section

  import OOTPUtilityWeb.Components.Team.Helpers

  prop team, :struct, required: true

  def render(assigns) do
    ~F"""
      <Section event_target={@myself}>
        <div class="flex gap-2 lg:gap-4">
          <img class="h-16 w-16 lg:h-28 lg:w-28 rounded-full" src={Routes.static_path(@socket, "/images/logos/#{@team.logo_filename}")} alt="">
          <div class="flex flex-col gap-2 lg:gap-4">
            <h1 class="text-2xl lg:text-4xl font-medium text-gray-900 whitespace-nowrap">{full_name(@team)}</h1>
            <div class="contents divide-y">
              <div class="flex flex-row gap-2 sm:gap-4 flex-wrap">
                <h2 class="text-base lg:text-xl font-medium text-gray-900">{division_standings(@team)}</h2>
                <h2 class="hidden md:block text-base lg:text-xl font-medium text-gray-900">{conference_standings(@team)}</h2>
              </div>
              <div class="flex flex-row gap-2 pt-2 lg:pt-4">
                <h3 class="text-sm lg:text-lg font-medium text-gray-900">{team_record(@team)}</h3>
                <h3 class="text-sm lg:text-lg font-medium text-gray-900">{games_behind(@team)}</h3>
              </div>
            </div>
          </div>
        </div>
        <Rankings team={@team} />
      </Section>
    """
  end

  def handle_event("viewport_resize", _viewport, socket) do
    {:noreply, socket}
  end

  defp full_name(%Teams.Team{name: name, nickname: nickname} = _team) do
    "#{name} #{nickname}"
  end

  defp division_standings(_team) do
    "2nd in AL East"
  end

  defp conference_standings(_team) do
    "3rd in American League"
  end
end
