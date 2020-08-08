defmodule OOTPUtility.Game.InningTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.{Fixtures}
  alias OOTPUtility.Game.Inning

  describe "new/3" do
    setup do
      game_id = 1
      inning_number = 1

      {lines_for_inning, {lines_for_visitor_frame, lines_for_home_frame}} =
        Fixtures.lines_for_inning(game_id, inning_number, as: :frames)

      inning = Inning.new(game_id, inning_number, lines_for_inning)

      {:ok,
       inning: inning,
       game_id: game_id,
       inning_number: inning_number,
       lines: %{
         inning: lines_for_inning,
         visitor_frame: lines_for_visitor_frame,
         home_frame: lines_for_home_frame
       }}
    end

    test "it returns an Inning.t() struct with the ID as $GAME_ID-$INNING_NUMBER", %{
      inning: inning,
      game_id: game_id,
      inning_number: inning_number
    } do
      inning_id = "#{game_id}-#{inning_number}"

      assert match?(
               %Inning{
                 id: ^inning_id
               },
               inning
             )
    end

    test "it returns an Inning.t() struct with the specified Game.t() ID", %{
      inning: inning,
      game_id: game_id
    } do
      assert match?(
               %Inning{
                 game_id: ^game_id
               },
               inning
             )
    end

    test "it returns an Inning.t() struct with the specified inning number", %{
      inning: inning,
      inning_number: inning_number
    } do
      assert match?(
               %Inning{
                 number: ^inning_number
               },
               inning
             )
    end

    test "it returns an Inning.t() struct with the vistor frame populated with a Frame.t() with the correct lines for the frame",
         %{
           inning: %Inning{visitor_frame: visitor_frame},
           inning_number: inning_number,
           game_id: game_id,
           lines: %{visitor_frame: lines_for_visitor_frame}
         } do
      inning_id = "#{game_id}-#{inning_number}"

      require IEx; IEx.pry

      assert(
        %Inning.Frame{
          inning_id: inning_id,
          orientation: :top,
          lines: lines_for_visitor_frame
        } == visitor_frame
      )
    end

    test "it returns an Inning.t() struct with the home frame populated with a Frame.t() with the correct lines for the frame",
         %{
           inning: %Inning{home_frame: home_frame},
           inning_number: inning_number,
           game_id: game_id,
           lines: %{home_frame: lines_for_home_frame}
         } do
      inning_id = "#{game_id}-#{inning_number}"

      assert(
        %Inning.Frame{
          inning_id: inning_id,
          orientation: :bottom,
          lines: lines_for_home_frame
        } ==
          home_frame
      )
    end
  end
end
