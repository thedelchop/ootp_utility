defmodule OOTPUtility.Leagues.Conference do
  use OOTPUtility.Schema, composite_key: [:league_id, :conference_id]
  import OOTPUtility.Imports, only: [import_from_path: 3]

  alias OOTPUtility.{League, Team}
  alias OOTPUtility.Leagues.Division

  @import_attributes [:id, :name, :abbr, :designated_hitter, :league_id]

  schema "conferences" do
    field :name, :string
    field :abbr, :string
    field :designated_hitter, :boolean, default: false

    belongs_to :league, League

    has_many :divisions, Division
    has_many :teams, Team
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
      |> map_import_attributes_to_schema
      |> build_association_ids
    end
  end

  defp map_import_attributes_to_schema(attrs) do
    attrs
    |> Map.put(:conference_id, Map.get(attrs, :sub_league_id))
    |> Map.delete(:sub_league_id)
  end

  defp build_association_ids(attrs) do
    attrs
    |> Map.put(:id, generate_composite_key(attrs))
    |> Map.delete(:conference_id)
  end

  @doc false
  def changeset(conference, attrs) do
    conference
    |> cast(attrs, @import_attributes)
    |> validate_required(@import_attributes)
  end
end
