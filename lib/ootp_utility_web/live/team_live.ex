defmodule OOTPUtilityWeb.TeamLive do
  use Surface.LiveView

  alias OOTPUtility.{Teams, Standings}
  alias OOTPUtilityWeb.Components.Team.{Leaders, Rankings, Roster}
  alias OOTPUtilityWeb.Components.{Scoreboard}
  alias OOTPUtilityWeb.Components.Shared.SectionHeader
  alias OOTPUtilityWeb.Components.Standings.Division, as: DivisionStandings
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  @impl true
  def render(assigns) do
    ~F"""
      <div class="flex flex-col space-y-4">
        <div class="max-w-7xl border rounded-2xl sm:p-6 lg:p-8 flex justify-between bg-white">
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
                  <h3 class="text-lg font-medium text-gray-900">{record(@team)}</h3>
                  <h3 class="text-lg font-medium text-gray-900">{games_behind(@team)} GB</h3>
                </div>
              </div>
            </div>
          </div>
          <Rankings team={@team} />
        </div>

        <div class="rounded-lg shadow bg-white p-4">
          <Scoreboard id="boston-red-sox-scoreboard" subject={@team} date={@team.league.current_date} />
        </div>

        <div class="flex space-x-4">
          <Roster id={"#{@team.slug}-roster"} team={@team} year={@team.league.season_year} class={"rounded-lg", "shadow", "bg-white", "p-4 grow"}/>
          <div class="flex flex-col w-1/3 space-y-4">
            <div class="flex flex-col rounded-lg shadow bg-white p-4">
              <SectionHeader>Standings</SectionHeader>
              <DivisionStandings id={"#{@team.slug}-standings"} compact={true} standings={@standings} />
            </div>
            <Leaders id={"#{@team.slug}-leaders"} team={@team}/>
            <div class="organization-summary"></div>
          </div>
        </div>
      </div>
    """
  end

  # end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    team = Teams.get_team_by_slug!(slug, preload: [:league, :division, :conference])
    standings = Standings.for_division(team.division)

    {
      :ok,
      socket
      |> assign(:team, team)
      |> assign(:standings, standings)
    }
  end

  defp full_name(%OOTPUtility.Teams.Team{name: name, nickname: nickname} = _team) do
    "#{name} #{nickname}"
  end

  defp division_standings(_team) do
    "2nd in AL East"
  end

  defp conference_standings(_team) do
    "3rd in American League"
  end

  defp record(_team) do
    "90-72"
  end

  defp games_behind(_team) do
    "5.5"
  end
end
