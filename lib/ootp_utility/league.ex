defmodule OOTPUtility.League do
  use OOTPUtility.Schema
  use OOTPUtility.Imports

  attributes_to_import([
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
  ])

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

  @impl OOTPUtility.Imports
  def sanitize_attributes(attrs) do
    attrs
    |> Map.put(:id, Map.get(attrs, :league_id))
    |> Map.delete(:league_id)
  end
end
