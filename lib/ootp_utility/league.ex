defmodule OOTPUtility.League do
  use OOTPUtility.Schema
  import OOTPUtility.Imports, only: [import_from_path: 3]

  @import_attributes [
    :id,
    :name,
    :abbr,
    :logo_filename,
    :start_date,
    :league_state,
    :season_year,
    :historical_year,
    :league_level,
    :current_date
  ]

  schema "leagues" do
    field :abbr, :string
    field :current_date, :date
    field :historical_year, :integer
    field :league_level, :string
    field :league_state, :string
    field :logo_filename, :string
    field :name, :string
    field :season_year, :integer
    field :start_date, :date

    belongs_to :parent_league, OOTPUtility.League

    has_many :child_leagues, OOTPUtility.League, foreign_key: :parent_league_id

    has_many :conferences, OOTPUtility.Leagues.Conference

    has_many :divisions, OOTPUtility.Leagues.Division

    has_many :teams, OOTPUtility.Team
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
      |> Map.put(:id, Map.get(atomized_attrs, :league_id))
      |> Map.delete(:league_id)
    end
  end

  @doc false
  def changeset(league, attrs) do
    league
    |> cast(attrs, @import_attributes)
    |> validate_required(@import_attributes)
  end
end
