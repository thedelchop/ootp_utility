defmodule OOTPUtilityWeb.PlayerController do
  use OOTPUtilityWeb, :controller

  alias OOTPUtility.{Players, Teams}

  def index(conn, %{"team_id" => team_id} = _params) do
    players =
      team_id
      |> Teams.get_team!()
      |> Players.for_team()

    render(conn, "index.html", players: players)
  end

  def show(conn, %{"slug" => slug}) do
    player = Players.get_player_by_slug!(slug)
    render(conn, "show.html", player: player)
  end
end
