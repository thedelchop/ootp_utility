defmodule OOTPUtility.World.City do
  use Ecto.Schema
  import Ecto.Changeset
  import OOTPUtility.Imports, only: [import_from_path: 2]

  @primary_key {:city_id, :id, autogenerate: false}
  schema "cities" do
    field :abbreviation, :string
    field :name, :string
  end

  def import_from_path(path) do
    import_from_path(path, &import_changeset/1)
  end

  def import_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:city_id, :name, :abbreviation])
    |> apply_changes()
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:city_id, :name, :abbreviation])
    |> validate_required([:city_id, :name, :abbreviation])
  end
end
