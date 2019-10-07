defmodule OOTPUtility.World.City do
  use OOTPUtility.Schema
  use OOTPUtility.Imports, attributes: [:id, :name, :abbreviation], from: "cities.csv"

  schema "cities" do
    field :abbreviation, :string
    field :name, :string
  end

  def sanitize_attributes(attrs) do
    attrs
    |> Map.put(:id, Map.get(attrs, :city_id))
    |> Map.delete(:city_id)
  end
end
