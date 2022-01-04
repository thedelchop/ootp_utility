defmodule OOTPUtilityWeb.Components.Team.Header do
  use Surface.LiveComponent

  alias OOTPUtility.Teams
  alias OOTPUtilityWeb.Components.Team.Rankings
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  import OOTPUtilityWeb.Components.Team.Helpers

  prop team, :struct, required: true

  def render(assigns) do
    ~F"""
      <div class="border rounded-2xl sm:p-6 lg:p-8 flex justify-between bg-white">
        <div class="flex space-x-4">
          <img class="h-28 w-28 rounded-full" src={Routes.static_path(@socket, "/images/logos/#{@team.logo_filename}")} alt="">
          <div class="flex flex-col space-y-4">
            <h1 class="text-4xl leading-6 font-medium text-gray-900">{full_name(@team)}</h1>
            <div>
              <div class="flex flex-row space-x-3">
                <h2 class="text-xl leading-6 font-medium text-gray-900">{division_standings(@team)}</h2>
                <h2 class="text-xl leading-6 font-medium text-gray-900">{conference_standings(@team)}</h2>
              </div>
              <hr class="my-2"/>
              <div class="flex flex-row space-x-2">
                <h3 class="text-lg font-medium text-gray-900">{team_record(@team)}</h3>
                <h3 class="text-lg font-medium text-gray-900">{games_behind(@team)}</h3>
              </div>
            </div>
          </div>
        </div>
        <Rankings team={@team} />
      </div>
    """
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
