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

    %{game | innings: seed_innings(game)}
  end

  defp seed_innings(%Game{id: game_id, log: %Log{lines: lines_for_game}}) do
    lines_for_game
    |> chunk_game_by_innings()
    |> Enum.with_index(1)
    |> Enum.map(fn
      {lines_for_inning, inning_number} ->
        Inning.new(game_id, inning_number, lines_for_inning)
    end)
  end

  defp chunk_game_by_innings(lines_for_game) do
    lines_for_game
    |> Enum.chunk_while(
      [],
      fn
        %Log.Line{type: 4} = line, inning_lines ->
          if includes_visitor_frame?(inning_lines) do
            {:cont, inning_lines ++ [line], []}
          else
            {:cont, inning_lines ++ [line]}
          end

        line, acc ->
          {:cont, acc ++ [line]}
      end,
      fn
        lines_for_inning ->
          {:cont, lines_for_inning, []}
      end
    )
  end

  defp includes_visitor_frame?(inning_lines), do: Enum.any?(inning_lines, &(&1.type == 4))
end
