defmodule OOTPUtility.Imports.Game.Log.Line do
  alias OOTPUtility.Imports
  alias OOTPUtility.Game.Log.Line

  @headers [
    "game_id",
    "type",
    "line",
    "text"
  ]

  @attribute_names [
    :game_id,
    :type,
    :line,
    :raw_text
  ]

  @spec import_from_path(Path.t()) :: {String.t(), integer}
  def import_from_path(path) do
    path
    |> Imports.read_from_path()
    |> Imports.trim_headers(@headers)
    |> Imports.build_attributes_map(@attribute_names, &csv_to_changeset/1)
    |> Imports.insert_into_database(Line)
  end

  defp csv_to_changeset([game_id, type, line, text]) do
    [
      String.to_integer(game_id),
      String.to_integer(type),
      String.to_integer(line),
      text
    ]
  end

  defp csv_to_changeset([game_id, type, line, text | rest_of_text]) do
    [
      String.to_integer(game_id),
      String.to_integer(type),
      String.to_integer(line),
      Enum.join([text | rest_of_text], ",")
    ]
  end
end
