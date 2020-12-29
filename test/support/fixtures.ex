defmodule OOTPUtility.Fixtures do
  defdelegate create_game_log_line(attrs), to: OOTPUtility.Fixtures.Game.Log.Line
  defdelegate build_game_log_line(attrs), to: OOTPUtility.Fixtures.Game.Log.Line
  defdelegate lines_for_inning(game, inning, opts), to: OOTPUtility.Fixtures.Game.Log.Line
  defdelegate lines_for_frame(game, inning, frame), to: OOTPUtility.Fixtures.Game.Log.Line
  defdelegate create_frame(attrs, opts), to: OOTPUtility.Fixtures.Game.Inning.Frame

  def lines_for_game(game_id) do
    for n <- 1..9 do
      lines_for_inning(game_id, n, as: :inning)
    end
  end
end
