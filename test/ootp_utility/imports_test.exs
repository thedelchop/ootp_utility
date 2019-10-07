defmodule OOTPUtility.ImportsTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Imports

  describe "trim_headers" do
    setup do
      {:ok, headers: ["game_id", "type", "line", "text"]}
    end

    test "it filters out any rows of the attributes list passed to it that match the specified headers",
         %{headers: headers} do
      values = ["1", "1", "1", "text"]

      csv_attributes = [
        headers,
        values,
        values
      ]

      assert [values, values] ==
               csv_attributes
               |> Imports.trim_headers(headers)
               |> Enum.to_list()
    end

    test "it filters nothing if no headers were included in the list of attributes being trimmed of its headers",
         %{headers: headers} do
      values = ["1", "1", "1", "text"]

      csv_attributes = [
        values,
        values,
        values
      ]

      assert [values, values, values] ==
               csv_attributes
               |> Imports.trim_headers(headers)
               |> Enum.to_list()
    end
  end

  describe "build_attributes" do
    setup do
      {:ok,
       attr_names: [:game_id, :type, :line, :raw_text],
       attr_values: [["1", "1", "1", "text"], ["1", "1", "1", "text"]]}
    end

    test "it returns a struct with the specified values being set on the specified keys, in the order they are passed",
         %{attr_names: attr_names, attr_values: attr_values} do
      assert [
               %{
                 game_id: "1",
                 type: "1",
                 line: "1",
                 raw_text: "text"
               },
               %{
                 game_id: "1",
                 type: "1",
                 line: "1",
                 raw_text: "text"
               }
             ] ==
               attr_values
               |> Imports.build_attributes_map(attr_names, fn attrs -> attrs end)
               |> Enum.to_list()
    end

    test "the values of the struct are updated using the transform function if nessecary",
         %{attr_names: attr_names, attr_values: attr_values} do
      transform_fn = fn
        [game_id, type, line, text] ->
          [
            String.to_integer(game_id),
            String.to_integer(type),
            String.to_integer(line),
            text
          ]
      end

      assert [
               %{
                 game_id: 1,
                 type: 1,
                 line: 1,
                 raw_text: "text"
               },
               %{
                 game_id: 1,
                 type: 1,
                 line: 1,
                 raw_text: "text"
               }
             ] ==
               attr_values
               |> Imports.build_attributes_map(attr_names, transform_fn)
               |> Enum.to_list()
    end
  end
end
