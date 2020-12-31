defmodule OOTPUtility.Imports.City do
  @type t() :: %__MODULE__{}

  use OOTPUtility.Schema
  use OOTPUtility.Imports, attributes: [:id, :name, :abbreviation], from: "cities.csv"

  alias OOTPUtility.Utilities

  schema "cities" do
    field :abbreviation, :string
    field :name, :string
  end

  def sanitize_attributes(attrs), do: Utilities.rename_keys(attrs, [{:city_id, :id}])
end
