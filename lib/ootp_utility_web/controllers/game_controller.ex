defmodule OOTPUtilityWeb.GameController do
  use OOTPUtilityWeb, :controller

  alias OOTPUtility.Games

  def index(conn, _params) do
    games = Games.list_games()
    render(conn, "index.html", games: games)
  end

  def show(conn, %{"id" => id}) do
    game = Games.get_game!(id)
    render(conn, "show.html", game: game)
  end
end
