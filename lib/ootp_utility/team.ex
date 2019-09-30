defmodule OOTPUtility.Team do
  use OOTPUtility.Schema
  import OOTPUtility.Imports, only: [import_from_path: 3]

  alias OOTPUtility.{League}
  alias OOTPUtility.Leagues.{Conference, Division}
  alias OOTPUtility.World.City

  @import_attributes [
    :id,
    :abbr,
    :name,
    :logo_filename,
    :level,
    :city_id,
    :league_id,
    :conference_id,
    :division_id
  ]

  schema "teams" do
    field :abbr, :string
    field :level, :string
    field :logo_filename, :string
    field :name, :string

    belongs_to :city, City

    belongs_to :league, League

    belongs_to :conference, Conference

    belongs_to :division, Division
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
    |> Map.put(:id, Map.get(attrs, :team_id))
    |> Map.put(:conference_id, Map.get(attrs, :sub_league_id))
    |> Map.put(:city_id, nil)
    |> Map.delete(:team_id)
    |> Map.delete(:sub_league_id)
  end

  defp build_association_ids(attrs) do
    attrs
    |> Map.put(:division_id, Division.generate_composite_key(attrs))
    |> Map.put(:conference_id, Conference.generate_composite_key(attrs))
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, @import_attributes)
    |> validate_required([
      :id,
      :abbr,
      :name,
      :logo_filename,
      :level,
      :league_id,
      :conference_id,
      :division_id
    ])
  end
end
