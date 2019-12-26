defmodule OOTPUtility.Leagues.DivisionTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Leagues.Division

  describe "build_attributes_for_import" do
    test "it correctly writes the binary ID" do
      division_attrs =
        Division.build_attributes_for_import(%{
          name: "Test Division",
          league_id: "1",
          sub_league_id: "2",
          division_id: "3"
        })

      assert division_attrs == %{
               name: "Test Division",
               league_id: "1",
               conference_id: "1-2",
               id: "1-2-3"
             }
    end
  end
end
