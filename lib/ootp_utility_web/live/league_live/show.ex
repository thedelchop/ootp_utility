defmodule OOTPUtilityWeb.LeagueLive.Show do
  use OOTPUtilityWeb, :live_view

  alias OOTPUtility.{Leagues,Standings}

  @impl true
  def render(%{standings: standings, socket: socket} = _assigns) do
    Phoenix.View.render(
      OOTPUtilityWeb.Standings.LeagueView,
      "league.html",
      conn: socket,
      standings: standings
    ) 
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    standings = slug
      |> Leagues.get_league!()
      |> Standings.for_league()

    {:ok, 
     socket
     |> assign(:standings, standings)
     |> assign(:socket, socket)}
  end

  @impl true
  def handle_params(_params, _session, socket) do
    {:noreply, socket}
  end
end
