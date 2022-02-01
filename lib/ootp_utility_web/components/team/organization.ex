defmodule OOTPUtilityWeb.Components.Team.Organization do
  use Surface.LiveComponent

  alias OOTPUtility.{Teams, Leagues}
  alias OOTPUtilityWeb.Components.Shared.{Section, SectionHeader}
  alias Surface.Components.LiveRedirect

  import OOTPUtilityWeb.Components.Team.Helpers, only: [team_record: 1, games_behind: 1]
  import OOTPUtilityWeb.Helpers.Path, only: [path_to_team: 2, path_to_team_logo: 2]

  prop team, :struct, required: true

  @impl true
  def render(assigns) do
    ~F"""
      <Section event_target={@myself} direction={:column} >
        <SectionHeader>Organization</SectionHeader>
        <ul role="list" class="divide-y divide-gray-200">
          {#for affiliate <- team_affiliates(@team) }
            <li class="py-2 md:py-4 flex justify-between relative">
              <div class="flex gap-2 md:gap-4 items-center mr-2 md:mr-4">
                <img class="h-6 md:h-10 w-6 md:w-10 rounded-full" src={path_to_team_logo(affiliate, @socket)} alt="" />
                <div>
                  <LiveRedirect class="text-base text-left text-gray-900" to={path_to_team(affiliate, @socket)}>
                    {name_with_league_level(affiliate)}
                  </LiveRedirect>
                  <div class={"text-base text-left text-gray-900"}>{league_level(affiliate)}</div>
                </div>
              </div>
              <div class="flex flex-col">
                <div class="text-lg md:text-2xl text-gray-700 whitespace-nowrap">{team_record(affiliate)}</div>
                <div class="text-xs md:text-sm text-right text-gray-500 uppercase">{games_behind(affiliate)}</div>
              </div>
            </li>
          {/for}
        </ul>
      </Section>
    """
  end

  @impl true
  def handle_event("viewport_resize", _viewport, socket) do
    {:noreply, socket}
  end

  def team_affiliates(%Teams.Team{} = team), do: Teams.get_affiliates(team, preload: [:record])

  def name_with_league_level(team) do
    "#{Teams.get_full_name(team)}"
  end

  def league_level(team) do
    team.level
    |> Leagues.get_league_level()
    |> Map.from_struct()
    |> Map.get(:abbr)
  end
end
