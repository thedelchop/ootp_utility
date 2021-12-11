defmodule OOTPUtility.Statistics.Batting do
  @moduledoc """
  The Statistics.Batting context.
  """
  import Ecto.Query, warn: false

  alias OOTPUtility.{Repo, Statistics, Players}

  def for_player(player_or_players, year)

  def for_player(players, year) when is_list(players) do
    player_ids = Enum.map(players, & &1.id)

    Statistics.Batting.Player
    |> where([bs], bs.year == ^year and bs.player_id in ^player_ids)
    |> order_by(:player_id)
    |> Repo.all()
  end

  def for_player(%Players.Player{id: player_id} = _player, year) do
    Statistics.Batting.Player
    |> where([bs], bs.year == ^year and bs.player_id == ^player_id)
    |> Repo.all()
  end
end
