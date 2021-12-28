defmodule OOTPUtility.Leagues.League do
  alias OOTPUtility.Leagues.{Conference, Division}
  alias OOTPUtility.Teams.Team
  alias __MODULE__

  @derive {Inspect, only: [:id, :name, :current_date, :season_year, :conferences, :divisions]}

  use OOTPUtility.Schema

  @derive {Phoenix.Param, key: :slug}
  schema "leagues" do
    field :name, :string
    field :abbr, :string
    field :slug, :string

    field :current_date, :date

    field :level, Ecto.Enum,
      values: [
        major: 1,
        triple_a: 2,
        double_a: 3,
        single_a: 4,
        low_a: 5,
        rookie: 6,
        international: 8,
        college: 10,
        high_school: 11
      ]

    field :logo_filename, :string
    field :season_year, :integer
    field :start_date, :date

    belongs_to :parent_league, League
    has_many :child_leagues, League, foreign_key: :parent_league_id

    has_many :conferences, Conference
    has_many :divisions, Division
    has_many :teams, Team
  end
end
