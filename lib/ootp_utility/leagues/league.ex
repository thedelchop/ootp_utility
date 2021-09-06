defmodule OOTPUtility.Leagues.League do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string

  schema "leagues" do
    field :abbr, :string
    field :current_date, :date
    field :league_level, :string
    field :logo_filename, :string
    field :name, :string
    field :season_year, :integer
    field :start_date, :date

    belongs_to :parent_league, OOTPUtility.Leagues.League
    has_many :child_leagues, OOTPUtility.Leagues.League, foreign_key: :parent_league_id

    timestamps()
  end

  @doc false
  def changeset(league, attrs) do
    league
    |> cast(attrs, [
      :abbr,
      :current_date,
      :league_level,
      :logo_filename,
      :name,
      :season_year,
      :start_date
    ])
    |> validate_required([
      :abbr,
      :current_date,
      :league_level,
      :logo_filename,
      :name,
      :season_year,
      :start_date
    ])
  end
end
