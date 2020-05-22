defmodule OOTPUtility.Fixtures.Game.Inning.Frame do
  import OOTPUtility.Fixtures, only: [build_game_log_line: 1]

  alias OOTPUtility.Game.Inning.Frame

  @attrs %{
    inning_id: 1,
    orientation: :top
  }

  def create_frame(attrs \\ %{}) do
    %{
      inning_id: inning_id,
      orientation: orientation,
      lines: lines
    } =
      attrs
      |> Enum.into(@attrs)
      |> Map.put_new(:lines, Enum.map(1..4, &build_game_log_line(%{line: &1})))

    Frame.new(inning_id, orientation, lines)
  end
end
