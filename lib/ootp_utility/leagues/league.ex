defmodule OOTPUtility.Leagues.League do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key { :league_id, :id, autogenerate: false}
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

    belongs_to :parent_league, OOTPUtility.Leagues.League, references: :parent_league_id
    has_many :child_leagues, OOTPUtility.Leagues.League, foreign_key: :parent_league_id, references: :league_id

    has_many :conferences, OOTPUtility.Leagues.Conference, foreign_key: :conference_id, references: :league_id
  end

  @doc false
  def changeset(league, attrs) do
    league
    |> cast(attrs, [:league_id, :name, :abbr, :logo_filename, :start_date, :league_state, :season_year, :historical_year, :league_level, :current_date])
    |> validate_required([:league_id, :name, :abbr, :logo_filename, :start_date, :league_state, :season_year, :historical_year, :league_level, :current_date])
  end
end
