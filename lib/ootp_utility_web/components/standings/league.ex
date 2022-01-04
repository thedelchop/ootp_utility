defmodule OOTPUtilityWeb.Components.Standings.League do
  use Surface.LiveComponent

  alias OOTPUtility.{Standings, Leagues}
  alias OOTPUtilityWeb.Components.Standings.{Conference, Division, Teams}
  alias OOTPUtilityWeb.Router.Helpers, as: Routes
  alias Surface.Components.LiveRedirect

  prop league, :struct, required: true

  data standings, :struct

  def update(assigns, socket) do
    standings = Standings.for_league(assigns.league)

    {
      :ok,
      socket
      |> assign(:league, assigns.league)
      |> assign(:standings, standings)
    }
  end

  def render(assigns) do
    ~F"""
      <div>
        <div class="pb-5 border-b border-gray-200">
          <div class="max-w-7xl mx-auto">
            <LiveRedirect to={path_to_league(@league, @socket)}>
              <h1 class="text-2xl font-semibold text-gray-900">
                {name(@league)}
              </h1>
            </LiveRedirect>
          </div>
        </div>
        <div class={"grid", "sm:grid-cols-1", "py-6", "px-3", "xl:grid-cols-2": has_conferences?(@league), "xl:gap-4": has_conferences?(@league)}>
          {#if has_children?(@league)}
            {#for child <- children(@league)}
              {render_child(child, @league)}
            {/for}
          {#else}
            <Teams id={child_id(@league, @standings.team_standings)} standings={@standings.team_standings} />
          {/if}
        </div>
      </div>
    """
  end

  def child_id(
    %Leagues.League{
      slug: league_slug
    },
    %Leagues.Division{
      slug: division_slug
    }) do
    [league_slug, division_slug, "standings"]
    |> Enum.join("-")
  end

  def child_id(
    %Leagues.League{
      slug: league_slug
    },
    %Leagues.Conference{
      slug: conference_slug
    }) do
    [league_slug, conference_slug, "standings"]
    |> Enum.join("-")
  end

  def render_child(%Leagues.Conference{} = conference, league) do
    assigns = %{league: league, conference: conference}

    ~F"""
      <Conference id={child_id(@league, @conference)} conference={@conference} />
    """
  end

  def render_child(%Leagues.Division{} = division, league) do
    assigns = %{league: league, division: division}

    ~F"""
      <Division id={child_id(@league, @division)} division={@division} />
    """
  end

  def has_children?(%Leagues.League{conferences: [], divisions: []}), do: false
  def has_children?(_), do: true

  def children(%Leagues.League{conferences: [], divisions: divisions}),
    do: divisions

  def children(%Leagues.League{conferences: conferences}), do: conferences

  def name(%Leagues.League{name: name}), do: name

  def has_conferences?(%Leagues.League{conferences: []}), do: false
  def has_conferences?(_), do: true

  def is_conference?(%Leagues.Conference{}), do: true
  def is_conference?(_), do: false

  def path_to_league(%Leagues.League{slug: slug}, socket) do
    Routes.live_path(socket, OOTPUtilityWeb.LeagueLive, slug)
  end
end
