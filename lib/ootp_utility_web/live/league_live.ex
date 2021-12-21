defmodule OOTPUtilityWeb.LeagueLive do
  use Surface.LiveView

  alias OOTPUtility.{Leagues, Standings}
  alias OOTPUtilityWeb.Components.Standings.League

  @impl true
  def render(assigns) do
    ~F"""
      <League id={@standings.id} standings={@standings} />
    """
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    standings =
      slug
      |> Leagues.get_league_by_slug!()
      |> Standings.for_league()

    {
      :ok,
      socket
      |> assign(:standings, standings)
      |> assign(:slug, slug)
    }
  end
end
