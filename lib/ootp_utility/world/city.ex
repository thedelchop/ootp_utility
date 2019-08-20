defmodule OOTPUtility.World.City do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:city_id, :id, autogenerate: false}
  schema "cities" do
    field :abbreviation, :string
    field :name, :string
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:city_id, :name, :abbreviation])
    |> validate_required([:city_id, :name, :abbreviation])
  end
end
