defmodule OOTPUtilityWeb.LeagueLive do
  use Surface.LiveView

  alias OOTPUtility.Leagues
  alias OOTPUtilityWeb.Components.Standings.League

  @impl true
  def render(assigns) do
    ~F"""
    <League id={"#{@slug}-standings"} league={@league} />
    """
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    league =
      slug
      |> Leagues.get_league_by_slug!()

    {
      :ok,
      socket
      |> assign(:league, league)
      |> assign(:slug, slug)
    }
  end
end
