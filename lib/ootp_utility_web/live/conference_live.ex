defmodule OOTPUtilityWeb.ConferenceLive do
  use Surface.LiveView

  alias OOTPUtility.{Leagues, Standings}
  alias OOTPUtilityWeb.Components.Standings.Conference

  @impl true
  def render(assigns) do
    ~F"""
      <Conference id={@standings.id} standings={@standings} />
    """
  end

  @impl true
  def mount(%{"league_slug" => league_slug, "slug" => slug}, _session, socket) do
    conference = Leagues.get_conference!(slug, league_slug)
    standings = Standings.for_conference(conference)

    {
      :ok,
      socket
      |> assign(:standings, standings)
      |> assign(:slug, slug)
    }
  end
end
