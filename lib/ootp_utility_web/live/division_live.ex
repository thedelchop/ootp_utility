defmodule OOTPUtilityWeb.DivisionLive do
  use Surface.LiveView

  alias OOTPUtility.{Leagues, Standings}
  alias OOTPUtilityWeb.Components.Standings.Division

  @impl true
  def render(assigns) do
    ~F"""
      <Division id={@standings.id} standings={@standings} />
    """
  end

  @impl true
  def mount(
        %{"league_slug" => league_slug, "conference_slug" => conference_slug, "slug" => slug},
        _session,
        socket
      ) do
    division = Leagues.get_division!(slug, league_slug, conference_slug)

    do_mount(division, slug, socket)
  end

  def mount(%{"league_slug" => league_slug, "slug" => slug}, _session, socket) do
    division = Leagues.get_division!(slug, league_slug)

    do_mount(division, slug, socket)
  end

  def do_mount(division, slug, socket) do
    standings = Standings.for_division(division)

    {
      :ok,
      socket
      |> assign(:standings, standings)
      |> assign(:slug, slug)
    }
  end
end
