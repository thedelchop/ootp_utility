defmodule OOTPUtilityWeb.TeamLive do
  use Surface.LiveView

  alias OOTPUtility.Teams
  alias OOTPUtilityWeb.Components.Team.{Header, Leaders, Roster, Organization}
  alias OOTPUtilityWeb.Components.{Scoreboard, Standings}
  alias OOTPUtilityWeb.Components.Shared.SectionHeader

  @impl true
  def render(assigns) do
    ~F"""
      <div class="flex flex-col space-y-4">
        <Header id={component_id_for(@team, "header")} team={@team} />
        <div class="rounded-lg shadow bg-white p-4">
          <Scoreboard id={component_id_for(@team, "scoreboard")} subject={@team} date={@team.league.current_date} />
        </div>

        <div class="flex space-x-4">
          <Roster id={component_id_for(@team, "roster")} team={@team} year={@team.league.season_year} class="grow" />
          <div class="flex flex-col w-1/3 space-y-4">
            <div class="flex flex-col rounded-lg shadow bg-white p-4">
              <SectionHeader>Standings</SectionHeader>
              {standings_for_team(@team)}
            </div>
            <Leaders id={component_id_for(@team, "leaders")} team={@team}/>
            <Organization id={component_id_for(@team, "organization")} team={@team} />
          </div>
        </div>
      </div>
    """
  end

  # end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    team =
      Teams.get_team_by_slug!(slug,
        preload: [
          league: [
            conferences: [
              divisions: [
                teams: [:record]
              ],
              teams: [:record]
            ],
            divisions: [
              teams: [:record]
            ],
            teams: [:record]
           ],
          conference: [
            :league,
            divisions: [
              teams: [:record]
            ],
            teams: [:record]
          ],
          division: [
            :league,
            :conference,
            teams: [:record]
          ]
        ]
      )

    {
      :ok,
      socket
      |> assign(:team, team)
    }
  end

  defp standings_for_team(%Teams.Team{division: nil, conference: nil, league: _league} = team) do
    assigns = %{team: team}

    ~F"""
      <Standings.League id={component_id_for(@team, "standings")} league={@team.league} />
    """
  end

  defp standings_for_team(%Teams.Team{division: nil, conference: _conf, league: _league} = team) do
    assigns = %{team: team}

    ~F"""
      <Standings.Conference id={component_id_for(@team, "standings")} conference={@team.conference} />
    """
  end

  defp standings_for_team(%Teams.Team{} = team) do
    assigns = %{team: team}

    ~F"""
      <Standings.Division id={component_id_for(@team, "standings")} compact={true} division={@team.division} />
    """
  end

  defp component_id_for(%Teams.Team{slug: slug}, component_name) do
    slug <> "-" <> component_name
  end
end
