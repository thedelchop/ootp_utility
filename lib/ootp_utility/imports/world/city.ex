defmodule OOTPUtility.Imports.World.City do

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

  def headers, do: @headers

  @spec csv_to_changeset([String.t()]) :: %{city_id: integer, name: String.t(), abbreviation: String.t()}
  def csv_to_changeset(city_as_csv) do
    [city_id, _nation_id, _state_id, name, abbreviation | _ ] = city_as_csv

    %{
      city_id: String.to_integer(city_id),
      name: name,
      abbreviation: abbreviation
    }
  end
end
