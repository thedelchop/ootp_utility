defmodule OOTPUtility.Imports.Game.Log.Line do
  import OOTPUtility.Imports
  alias OOTPUtility.Game.Log.Line

  @headers [
    "game_id",
    "type",
    "line",
    "text"
  ]

  @def """
  Accepts a line of CSV representing a game log line.

  NOTE: The second pattern match is neccesary because the output from OOTP does not
        correctly encode commas that exist in the game text, causing the decoder to
        break the line into more entries than there are headers
  """
  @spec csv_to_changeset([String.t()]) :: %Line{}
  def csv_to_changeset([game_id, type, line, text | rest_of_text]) do
    %{
      game_id: String.to_integer(game_id),
      type: String.to_integer(type),
      line: String.to_integer(line),
      raw_text: Enum.join([text | rest_of_text], ",")
    }
  end

  def csv_to_changeset([game_id, type, line, text]) do
    %{
      game_id: String.to_integer(game_id),
      type: String.to_integer(type),
      line: String.to_integer(line),
      raw_text: text
    }
  end
end
