defmodule OOTPUtility.Game.Inning do
  defstruct [:id, :game_id, :number, :home_frame, :visitor_frame]

  @type t() :: %__MODULE__{}

  alias __MODULE__
  alias OOTPUtility.Game.Log.Line

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
        &({:cont, &1})
      ) do
        [] -> [[], []]
        lines -> lines
      end

    new(game_id, inning_number, lines_for_visitor_frame, lines_for_home_frame)
  end

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
end
