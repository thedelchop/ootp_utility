defmodule OOTPUtility.Imports.World.City do
  alias OOTPUtility.Imports
  alias OOTPUtility.World.City

  @headers [
    "city_id",
    "nation_id",
    "state_id",
    "name",
    "abbreviation",
    "latitude",
    "longitude",
    "population",
    "main_language_id"
  ]

  @attributes [
    :city_id,
    :name,
    :abbreviation
  ]

  @spec import_from_path(Path.t()) :: {String.t(), integer}
  def import_from_path(path) do
    path
    |> Imports.read_from_path()
    |> Imports.trim_headers(@headers)
    |> Imports.build_attributes_map(@attributes, &csv_to_changeset/1)
    |> Imports.insert_into_database(City)
  end

  defp csv_to_changeset([city_id, _nation_id, _state_id, name, abbreviation | _]) do
    [
      String.to_integer(city_id),
      name,
      abbreviation
    ]
  end
end
