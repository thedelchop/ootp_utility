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
  def mount(%{"slug" => slug}, _session, socket) do
    division = Leagues.get_division_by_slug!(slug)

    standings = Standings.for_division(division)

    {
      :ok,
      socket
      |> assign(:standings, standings)
      |> assign(:slug, slug)
    }
  end
end
