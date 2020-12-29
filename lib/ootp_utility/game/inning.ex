defmodule OOTPUtility.Game.Inning do
  defstruct [:id, :game_id, :number, :home_frame, :visitor_frame]

  @type t() :: %__MODULE__{}

  alias __MODULE__
  alias OOTPUtility.Game
  alias OOTPUtility.Game.Log
  alias OOTPUtility.Game.Log.Line

  @doc """
    Returns a list of innings for the specified game, creating one for each inning in the game's log
  """
  @spec from_game(Game.t()) :: [Inning.t()]
  def from_game(%Game{id: game_id, log: %Log{lines: lines_for_game}}) do
    lines_for_game
    |> chunk_game_by_innings()
    |> Enum.map(fn
      {inning_number, lines_for_inning} ->
        Inning.new(game_id, inning_number, lines_for_inning)
    end)
  end

  @doc """
    Returns a new %Inning{}, giving the game_id, inning_number and the log lines for the inning.
  """
  @spec new(integer(), integer(), [Log.Line.t()]) :: Inning.t()
  def new(game_id, inning_number, lines_for_inning) do
    [lines_for_visitor_frame, lines_for_home_frame] =
      case Enum.chunk_while(
             lines_for_inning,
             [],
             fn
               %Line{type: 4} = line, acc ->
                 {:cont, Enum.reverse([line | acc]), []}

               line, acc ->
                 {:cont, [line | acc]}
             end,
             &{:cont, &1}
           ) do
        [] -> [[], []]
        lines -> lines
      end

    new(game_id, inning_number, lines_for_visitor_frame, lines_for_home_frame)
  end

  @spec new(integer(), integer(), [Log.Line.t()], [Log.Line.t()]) :: Inning.t()
  def new(game_id, inning_number, lines_for_visitor_frame, lines_for_home_frame) do
    with inning_id <- Enum.join([game_id, inning_number], "-") do
      %Inning{
        id: inning_id,
        game_id: game_id,
        number: inning_number,
        visitor_frame: Inning.Frame.new(inning_id, :top, lines_for_visitor_frame),
        home_frame: Inning.Frame.new(inning_id, :bottom, lines_for_home_frame)
      }
    end
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
    |> Enum.with_index(1)
    |> Enum.map(fn
      {inning, number} -> {number, inning}
    end)
  end

  defp includes_visitor_frame?(inning_lines), do: Enum.any?(inning_lines, &(&1.type == 4))
end
