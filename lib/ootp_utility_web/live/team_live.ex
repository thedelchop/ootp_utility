defmodule OOTPUtilityWeb.TeamLive do
  use Surface.LiveView

  alias OOTPUtility.Teams
  alias OOTPUtilityWeb.Components.Team.{Leaders, Rankings}
  alias OOTPUtilityWeb.Components.Scoreboard
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  @impl true
  def render(assigns) do
    ~F"""
      <div id="team-banner" class="max-w-7xl mx-auto sm:px-6 lg:px-8 flex">

        <div id="team-header" class="flex-none">
          <img class="h-10 w-10 rounded-full" src={Routes.static_path(@socket, "/images/logos/#{@team.logo_filename}")} alt="">
          <div class="flex flex-col">
            <h1>{full_name(@team)}</h1>
            <div class="flex flex-row">
              <h2>{division_standings(@team)}</h2>
              <h2>{conference_standings(@team)}</h2>
            </div>
            <hr />
            <div class="flex flex-row">
              <h3>{record(@team)}</h3>
              <h3>{games_behind(@team)} GB</h3>
            </div>
          </div>
        </div>
        <Rankings team={@team} />
      </div>

      <Scoreboard id="#{@team.id}-scoreboard" subject={@team} date={@team.league.current_date} />

      <div class="main">
        <div class="left-column">
          <div class="next-game"></div>
          <div class="standings"></div>
        </div>
        <div class="center-column">
          <div class="starters"></div>
          <div class="bullpen"></div>
          <div class="catchers"></div>
          <div class="infielders"></div>
          <div class="outfielders"></div>
        </div>
        <div class="right-column flex flex-row">
          <Leaders id={@team.id} team={@team}/>
          <div class="streaks"></div>
          <div class="organization-summary"></div>
        </div>
      </div>
    """
  end

  # end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    team = Teams.get_team_by_slug!(slug, [:league, :division, :conference])

    {:ok, assign(socket, :team, team)}
  end

  defp full_name(%OOTPUtility.Teams.Team{name: name, nickname: nickname} = _team) do
    name <> " " <> nickname
  end

  defp division_standings(_team) do
    "2nd in AL East"
  end

  defp conference_standings(_team) do
    "5rd in American League"
  end

  defp record(_team) do
    "90-72"
  end

  defp games_behind(_team) do
    "5.5"
  end
end
