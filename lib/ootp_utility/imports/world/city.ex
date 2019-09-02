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

  @spec import_from_path(Path.t()) :: {String.t(), integer}
  def import_from_path(path) do
    path
    |> Imports.read_from_path()
    |> Imports.trim_headers(@headers)
    |> Stream.map(&csv_to_changeset(&1))
    |> Imports.insert_into_database()
  end

  def csv_to_changeset(city_as_csv) do
    @headers
    |> Enum.zip(city_as_csv)
    |> Enum.into(%{})
    |> City.import_changeset()
  end
end
