defmodule OOTPUtility.Statistics.Pitching do
  @moduledoc """
  The Statistics.Pitching context.
  """

  import Ecto.Query, warn: false
  alias OOTPUtility.Repo

  alias OOTPUtility.Players
  alias OOTPUtility.Statistics.Pitching.{Player, Team}

  def for_player(player_or_players, year)

  def for_player(players, year) when is_list(players) do
    player_ids = Enum.map(players, & &1.id)

    Player
    |> where([bs], bs.year == ^year and bs.player_id in ^player_ids)
    |> order_by(:player_id)
    |> Repo.all()
  end

  def for_player(%Players.Player{id: player_id} = _player, year) do
    Player
    |> where([bs], bs.year == ^year and bs.player_id == ^player_id)
    |> Repo.all()
  end

  @doc """
  Returns the list of team_pitching_stats.

  ## Examples

      iex> list_team_pitching_stats()
      [%Team{}, ...]

  """
  def list_team_pitching_stats do
    Repo.all(Team)
  end
end
