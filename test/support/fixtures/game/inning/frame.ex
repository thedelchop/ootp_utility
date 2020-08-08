defmodule OOTPUtility.Fixtures.Game.Inning.Frame do
  import OOTPUtility.Fixtures.Game.Log.Line, only: [lines_for_frame: 3]

  alias OOTPUtility.Game.Inning.Frame

  @attrs %{
    inning_id: 1,
    orientation: :top
  }

  def create_frame(attrs \\ %{}, [{:game, game}, {:inning, inning}] \\ [{:game, 1}, {:inning, 1}]) do
    frame_attrs =
      attrs
      |> Enum.into(@attrs)

    %{
      inning_id: inning_id,
      orientation: orientation,
      lines: lines
    } =
      frame_attrs
      |> Map.put_new(:lines, lines_for_frame(game, inning, Map.get(attrs, :orientation)))

    Frame.new(inning_id, orientation, lines)
  end
end
