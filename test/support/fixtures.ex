defmodule OOTPUtility.Fixtures do
  defdelegate create_game_log_line(attrs), to: OOTPUtility.Fixtures.Game.Log.Line
  defdelegate build_game_log_line(attrs), to: OOTPUtility.Fixtures.Game.Log.Line
  defdelegate create_frame(attrs), to: OOTPUtility.Fixtures.Game.Inning.Frame
end
