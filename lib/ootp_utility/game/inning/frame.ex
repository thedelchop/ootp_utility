defmodule OOTPUtility.Game.Inning.Frame do
  defstruct [:inning_id, :orientation, :lines]

  @type t() :: %__MODULE__{}

  alias __MODULE__

  def new(inning_id, orientation, lines) do
    %Frame{
      inning_id: inning_id,
      orientation: orientation,
      lines: lines
    }
  end
end
