defmodule OOTPUtilityWeb.Components.Standings.League do
  use Surface.LiveComponent

  alias OOTPUtility.{Standings, Leagues}
  alias OOTPUtilityWeb.Components.Standings.{Conference, Division, Teams}
  alias OOTPUtilityWeb.Components.Shared.{Section, SectionHeader}
  alias Surface.Components.LiveRedirect

  import OOTPUtilityWeb.Helpers.Path, only: [path_to_league: 2]

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
      <Section event_target={@myself} direction={:column} border={false}>
        <SectionHeader>
          <LiveRedirect to={path_to_league(@league, @socket)}>
            <h1 class="text-2xl font-semibold text-gray-900">
              {name(@league)}
            </h1>
          </LiveRedirect>
        </SectionHeader>
        <div class={"grid", "grid-cols-1", "gap-4", "py-4", "px-2", "md:grid-cols-2": has_conferences?(@league), "md:gap-8": has_conferences?(@league)}>
          {#if has_children?(@league)}
            {#for child <- children(@league)}
              {render_child(child, @league)}
            {/for}
          {#else}
            <Teams id={child_id(@league, @standings.team_standings)} standings={@standings.team_standings} />
          {/if}
        </div>
      </Section>
    """
  end

  def handle_event("viewport_resize", _viewport, socket) do
    {:noreply, socket}
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

  def child_id(
    %Leagues.League{
      slug: league_slug
    },
    _team_standings
    )do
    [league_slug, "standings"]
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
end
