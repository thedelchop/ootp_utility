defmodule OOTPUtilityWeb.Components.Team.Organization do
  use Surface.LiveComponent

  alias OOTPUtility.{Teams, Leagues}
  alias OOTPUtilityWeb.Components.Shared.SectionHeader
  alias OOTPUtilityWeb.Router.Helpers, as: Routes
  alias OOTPUtilityWeb.TeamLive
  alias Surface.Components.LiveRedirect

  import OOTPUtilityWeb.Components.Team.Helpers, only: [team_record: 1, games_behind: 1]

  prop team, :struct, required: true

  @impl true
  def render(assigns) do
    ~F"""
      <div class="flex flex-col rounded-lg shadow bg-white p-4">
        <SectionHeader>Organization</SectionHeader>
        <ul role="list" class="divide-y divide-gray-200">
          {#for affiliate <- @team.affiliates }
            <li class="py-4 flex justify-between relative">
              <div class="flex space-x-4 items-center">
                <img class="h-6 lg:h-10 w-6 lg:w-10 rounded-full" src={path_to_logo(@socket, affiliate)} alt="">
                <LiveRedirect class="text-base text-left text-gray-700" to={path_to_team(affiliate, @socket)}>
                  {name_with_league_level(affiliate)}
                </LiveRedirect>
              </div>
              <div class="flex flex-col">
                <div class="text-2xl text-gray-900">{team_record(affiliate)}</div>
                <div class="text-xs text-right text-gray-500 uppercase">{games_behind(affiliate)}</div>
              </div>
            </li>
          {/for}
        </ul>
      </div>
    """
  end

  def name_with_league_level(team) do
    "#{Teams.get_full_name(team)} (#{league_level(team)})"
  end

  def league_level(team) do
    team.level
    |> Leagues.get_league_level()
    |> Map.from_struct()
    |> Map.get(:abbr)
  end

  defp path_to_logo(socket, team) do
    Routes.static_path(socket, "/images/logos/#{team.logo_filename}")
  end

  def path_to_team(team, socket) do
    Routes.live_path(socket, TeamLive, team.slug)
  end
end
