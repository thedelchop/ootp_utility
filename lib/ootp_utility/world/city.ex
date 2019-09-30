defmodule OOTPUtility.World.City do
  use OOTPUtility.Schema
  import OOTPUtility.Imports, only: [import_from_path: 3]

  @import_attributes [:id, :name, :abbreviation]

  schema "cities" do
    field :abbreviation, :string
    field :name, :string
  end

  def import_from_path(path) do
    import_from_path(path, __MODULE__, &build_attributes_for_import/1)
  end

  def build_attributes_for_import(attrs) do
    %__MODULE__{}
    |> changeset(sanitize_attributes(attrs))
    |> apply_changes()
    |> Map.take(@import_attributes)
  end

  def sanitize_attributes(attrs) do
    with {:ok, atomized_attrs} <- Morphix.atomorphiform(attrs) do
      atomized_attrs
      |> Map.put(:id, Map.get(atomized_attrs, :city_id))
      |> Map.delete(:city_id)
    end
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, @import_attributes)
    |> validate_required(@import_attributes)
  end
end
