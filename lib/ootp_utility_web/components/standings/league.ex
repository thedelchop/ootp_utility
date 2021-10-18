defmodule OOTPUtilityWeb.Components.Standings.League do
  use Surface.LiveComponent

  alias OOTPUtility.{Standings, Leagues}
  alias OOTPUtilityWeb.Components.Standings.{Conference, Division}
  alias Surface.Components.Link
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  prop standings, :struct, required: true

  def render(assigns) do
    ~F"""
      <div>
        <div class="pb-5 border-b border-gray-200">
          <div class="max-w-7xl mx-auto">
            <Link to={path_to_league(@standings, @socket)}>
              <h1 class="text-2xl font-semibold text-gray-900">
                {name(@standings)}
              </h1>
            </Link>
          </div>
        </div>
        <div class={"grid", "sm:grid-cols-1", "py-6", "px-3", "xl:grid-cols-2": has_conferences?(@standings), "xl:gap-4": has_conferences?(@standings)}>
            {#for standings <- child_standings(@standings)}
              {#if has_conferences?(@standings) }
                <Conference standings={standings} />
              {#else}
                <Division standings={standings} />
              {/if}
            {/for}
        </div>
      </div>
    """
  end

  def child_standings(%Standings.League{conference_standings: [], division_standings: standings}), do: standings
  def child_standings(%Standings.League{conference_standings: standings}), do: standings

  def name(%Standings.League{league: %Leagues.League{name: name}} = _standings), do: name

  def has_conferences?(%Standings.League{conference_standings: []} = _), do: false
  def has_conferences?(_), do: true

  def path_to_league(%Standings.League{league: %Leagues.League{slug: slug}} = _standings, socket) do
    Routes.league_path(socket, :show, slug)
  end
end
