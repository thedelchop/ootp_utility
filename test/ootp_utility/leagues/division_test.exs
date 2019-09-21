defmodule OOTPUtility.Leagues.DivisionTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Leagues.Division

  describe "import_changset" do
    test "it correctly writes the binary ID" do
      division =
        Division.import_changeset(%{
          name: "Test Division",
          league_id: "1",
          conference_id: "2",
          division_id: "3"
        })

      attrs =
        division
        |> Map.from_struct()
        |> Map.take([:id, :name, :league_id, :conference_id])

      assert attrs == %{
               name: "Test Division",
               league_id: "1",
               conference_id: "2",
               id: "1-2-3"
             }
    end
  end
end
