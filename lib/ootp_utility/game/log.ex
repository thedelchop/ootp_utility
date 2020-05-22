defmodule OOTPUtility.Game.Log do
  @moduledoc """
  The GameLog context.
  """
  defstruct [:game_id, :lines]

  @type t() :: %__MODULE__{}

  alias __MODULE__

  alias OOTPUtility.{Game, Repo}
  alias OOTPUtility.Game.Log.{Line}

  @doc """
  Returns a OOTPUtility.Game.Log.t() struct populated with the
  list of OOTPUtility.Game.Log.Line.t() populated for the specified
  OOTPUtility.Game.t()

  ## Parameters

  ### new/1
    * game: A Game.t() struct

    OR

    * game_id: The :id of a Game.t()

  ## Examples

  iex> OOTPUtility.Game.Log.new(1)
  %OOTPUtility.Game.Log{game_id: 1, lines: [%OOTPUtility.Game.Log.Line{game_id: 1}]}

  iex> game = %OOTPUtility.Game{id: 1};
  ...> OOTPUtility.Game.Log.new(game)
  %OOTPUtility.Game.Log{game_id: 1, lines: [%OOTPUtility.Game.Log.Line{game_id: 1}]}
  """
  @spec new(Game.t() | number()) :: Log.t()
  def new(%Game{id: game_id}) do
    new(game_id)
  end

  def new(game_id) do
    %Log{
      game_id: game_id,
      lines: game_id |> Line.for_game() |> Repo.all()
    }
  end
end
