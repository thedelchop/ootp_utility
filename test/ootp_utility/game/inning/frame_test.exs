defmodule OOTPUtility.Game.Inning.FrameTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.{Fixtures}
  alias OOTPUtility.Game.Inning.Frame

  describe "new/3" do
    setup do
      frame_lines = Enum.map(1..4, &Fixtures.create_game_log_line(%{line: &1}))

      {:ok, frame_lines: frame_lines}
    end

    test "it returns a Frame.t() struct with the specified inning ID", %{frame_lines: frame_lines} do
      assert match?(
               %Frame{
                 inning_id: 1
               },
               Frame.new(1, :top, frame_lines)
             )
    end

    test "it returns a Frame.t() struct with the orientation", %{frame_lines: frame_lines} do
      assert match?(
               %Frame{
                 orientation: :top
               },
               Frame.new(1, :top, frame_lines)
             )
    end

    test "it returns a Frame.t() struct with the associated Game.Log.Lines.t()", %{
      frame_lines: frame_lines
    } do
      assert match?(
               %Frame{
                 lines: ^frame_lines
               },
               Frame.new(1, :top, frame_lines)
             )
    end
  end
end
