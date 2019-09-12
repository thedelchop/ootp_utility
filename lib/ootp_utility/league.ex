defmodule OOTPUtility.League do
  use OOTPUtility.Schema
  import OOTPUtility.Imports, only: [import_from_path: 3]

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
    import_from_path(path, __MODULE__, &import_changeset/1)
  end

  def import_changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> apply_changes
  end

  @doc false
  def changeset(league, attrs) do
    league
    |> cast(attrs, [
      :league_id,
      :name,
      :abbr,
      :logo_filename,
      :start_date,
      :league_state,
      :season_year,
      :historical_year,
      :league_level,
      :current_date
    ])
    |> validate_required([
      :league_id,
      :name,
      :abbr,
      :logo_filename,
      :start_date,
      :league_state,
      :season_year,
      :historical_year,
      :league_level,
      :current_date
    ])
  end
end
