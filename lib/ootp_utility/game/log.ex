defmodule OOTPUtility.Game.Log do
  alias OOTPUtility.Game.Log.Line
  alias OOTPUtility.Repo

  import Ecto.Query, only: [where: 3, order_by: 3]

  @moduledoc """
  The GameLog context.
  """

  @doc """
  Return all of the lines related to the specfied game, sorted by their line number.
  This will return a log, which which describes the game in a pitch by pitch basis.
  """
  @spec lines_for_game(integer) :: {:ok, [Line.t()]} | {:error, String.t()}
  def lines_for_game(game_id) do
    Line
    |> where([l], l.game_id == ^game_id)
    |> order_by([l], l.line)
    |> Repo.all()
  end
end
