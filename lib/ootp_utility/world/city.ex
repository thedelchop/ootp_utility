defmodule OOTPUtility.World.City do
  use OOTPUtility.Schema
  import OOTPUtility.Imports, only: [import_from_path: 3]

  schema "cities" do
    field :abbreviation, :string
    field :name, :string
  end

  def import_from_path(path) do
    import_from_path(path, __MODULE__, &import_changeset/1)
  end

  def import_changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> apply_changes()
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:city_id, :name, :abbreviation])
    |> validate_required([:city_id, :name, :abbreviation])
  end
end
