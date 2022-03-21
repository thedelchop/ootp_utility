defmodule OOTPUtilityWeb.DivisionLive do
  use Surface.LiveView

  alias OOTPUtility.Leagues
  alias OOTPUtilityWeb.Components.Standings.Division

  @impl true
  def render(assigns) do
    ~F"""
    <Division id={"#{@slug}-standings"} division={@division} />
    """
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    division = Leagues.get_division_by_slug!(slug)

    {
      :ok,
      socket
      |> assign(:division, division)
      |> assign(:slug, slug)
    }
  end
end
