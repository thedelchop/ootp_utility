defmodule OOTPUtilityWeb.ConferenceLive do
  use Surface.LiveView

  alias OOTPUtility.Leagues
  alias OOTPUtilityWeb.Components.Standings.Conference

  @impl true
  def render(assigns) do
    ~F"""
    <Conference id={"#{@conference.slug}-standinhgs"} conference={@conference} />
    """
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    conference = Leagues.get_conference_by_slug!(slug)

    {:ok, assign(socket, :conference, conference)}
  end
end
