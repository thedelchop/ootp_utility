defmodule OOTPUtilityWeb.TeamLive do
  use Surface.LiveView

  alias OOTPUtilityWeb.Components.Team.{Header, Leaders, Roster, Organization}
  alias OOTPUtilityWeb.Components.{Scoreboard}
  alias OOTPUtilityWeb.Components.Shared.SectionHeader
  alias OOTPUtilityWeb.Components.Standings.Division, as: DivisionStandings

  alias OOTPUtility.Teams

  @impl true
  def render(assigns) do
    ~F"""
    <div class="flex flex-col gap-4">
      <Header id={component_id_for(@team, "header")} team={@team} />

      <Scoreboard
        id={component_id_for(@team, "scoreboard")}
        subject={@team}
        date={@team.league.current_date}
      />

      <div class="flex flex-col lg:flex-row gap-4">
        <Roster
          id={component_id_for(@team, "roster")}
          team={@team}
          year={@team.league.season_year}
          class="grow"
        />
        <div class="flex flex-col gap-4">
          <div class="flex flex-col rounded-lg shadow bg-white p-4">
            <SectionHeader>Standings</SectionHeader>
            <DivisionStandings id={component_id_for(@team, "standings")} compact division={@team.division} />
          </div>
          <Leaders id={component_id_for(@team, "leaders")} team={@team} />
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
        preload: [:league, conference: [:league], division: [:league, :conference]]
      )

    {
      :ok,
      socket
      |> assign(:team, team)
    }
  end

  defp component_id_for(%Teams.Team{slug: slug}, component_name) do
    slug <> "-" <> component_name
  end
end
