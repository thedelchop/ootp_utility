defmodule OOTPUtilityWeb.Components.Standings.Conference do
  use Surface.Component

  alias OOTPUtility.{Standings, Leagues}
  alias OOTPUtilityWeb.Components.Standings.{Division, Teams}
  alias Surface.Components.LiveRedirect
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  prop standings, :struct, required: true

  def render(assigns) do
    ~F"""
      <div class="shadow border-b border-gray-200 rounded-lg">
        <div class="col-span-2 pb-5 border-b border-gray-200">
          <LiveRedirect to={path_to_conference(@standings, @socket)}>
            <h3 class="mt-3 ml-3 text-md leading-6 font-medium text-gray-900">
              {name(@standings)}
            </h3>
          </LiveRedirect>
        </div>
        <div class="grid grid-cols-1 gap-4 lg:gap-8">
          {#for standings <- child_standings(@standings)}
            {#if has_divisions?(@standings) }
              <Division standings={standings} />
            {#else}
              <Teams standings={standings} />
            {/if}
          {/for}
        </div>
      </div>
    """
  end

  def name(%Standings.Conference{conference: %Leagues.Conference{name: name}} = _standings),
    do: name

  def child_standings(%Standings.Conference{
        division_standings: [],
        team_standings: standings
      }),
      do: standings

  def child_standings(%Standings.Conference{division_standings: standings}), do: standings

  def has_divisions?(%Standings.Conference{division_standings: []} = _), do: false
  def has_divisions?(_), do: true

  def path_to_conference(
        %Standings.Conference{
          conference: %Leagues.Conference{
            league: %Leagues.League{
              slug: league_slug
            },
            slug: slug
          }
        } = _standings,
        socket
      ) do
    Routes.conference_path(socket, :show, league_slug, slug)
  end
end
