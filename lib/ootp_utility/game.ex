defmodule OOTPUtility.Game do
  defstruct [:id, :log, :innings]

  @type t() :: %__MODULE__{}

  alias __MODULE__
  alias OOTPUtility.Game.{Log, Inning}

  @spec new(integer()) :: Game.t()
  def new(game_id) do
    new(game_id, Log.new(game_id))
  end

  @spec new(integer(), Game.Log.t()) :: Game.t()
  def new(game_id, log) do
    game = %Game{
      id: game_id,
      log: log
    }

    %{game | innings: Inning.from_game(game)}
  end
end
