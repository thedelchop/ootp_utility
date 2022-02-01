defmodule OOTPUtilityWeb.Components.Team.Header do
  use Surface.LiveComponent

  alias Surface.Components.LiveRedirect

  alias OOTPUtility.{Leagues, Standings, Teams}

  alias OOTPUtilityWeb.Components.Team.Rankings
  alias OOTPUtilityWeb.Components.Shared.Section

  import OOTPUtilityWeb.Components.Team.Helpers
  import OOTPUtilityWeb.Helpers, only: [ordinalize: 1]
  import OOTPUtilityWeb.Helpers.Path

  prop team, :struct, required: true

  def render(assigns) do
    ~F"""
      <Section event_target={@myself}>
        <div class="flex gap-2 lg:gap-4">
          <img class="h-16 w-16 lg:h-28 lg:w-28 rounded-full" src={path_to_team_logo(@team, @socket)} alt="">
          <div class="flex flex-col gap-2 lg:gap-4">
            <h1 class="text-2xl lg:text-4xl font-medium text-gray-900 whitespace-nowrap">{full_name(@team)}</h1>
            <div class="contents divide-y">
              <div class="flex flex-row gap-2 sm:gap-4 flex-wrap">
                <h2 class="text-base lg:text-xl font-medium text-gray-900">{standings(@team, @socket)}</h2>
                <h2 class="hidden md:block text-base lg:text-xl font-medium text-gray-900">{standings_in_parent_league(@team, @socket)}</h2>
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

  defp standings(%Teams.Team{division: nil, conference: nil, league: league} = team, socket) do
    do_standings(team, league, socket)
  end

  defp standings(%Teams.Team{division: nil, conference: conference} = team, socket) do
    do_standings(team, conference, socket)
  end

  defp standings(%Teams.Team{division: division} = team, socket) do
    do_standings(team, division, socket)
  end

  defp do_standings(team, parent, socket) do
    team
    |> Standings.for_team()
    |> render_standings_link(parent, socket)
  end

  defp standings_in_parent_league(
         %Teams.Team{division: nil, conference: nil, league: _league} = _team,
         _socket
       ),
       do: ""

  defp standings_in_parent_league(
         %Teams.Team{division: nil, conference: _conference, league: league} = team,
         socket
       ) do
    do_standings_in_parent_league(team, league, socket)
  end

  defp standings_in_parent_league(
         %Teams.Team{division: _division, conference: conference} = team,
         socket
       ) do
    do_standings_in_parent_league(team, conference, socket)
  end

  defp do_standings_in_parent_league(team, parent, socket) do
    team
    |> Standings.for_team(parent)
    |> render_standings_link(parent, socket)
  end

  def render_standings_link(%Standings.Team{position: position} = _standings, parent, socket) do
    assigns = %{position: position, parent: parent, socket: socket}

    ~F"""
      <LiveRedirect to={path_to_parent(@parent, @socket)}>
        {ordinalize(@position)} in {@parent.name}
      </LiveRedirect>
    """
  end

  defp path_to_parent(%Leagues.Conference{} = conf, socket), do: path_to_conference(conf, socket)

  defp path_to_parent(%Leagues.Division{} = division, socket),
    do: path_to_division(division, socket)

  defp path_to_parent(%Leagues.League{} = league, socket), do: path_to_league(league, socket)
end
