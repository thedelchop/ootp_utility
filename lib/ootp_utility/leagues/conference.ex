defmodule OOTPUtility.Leagues.Conference do
  alias OOTPUtility.Leagues.{Division, League}
  alias OOTPUtility.Teams.Team

  @derive {Inspect, only: [:id, :name, :league, :divisions]}

  use OOTPUtility.Schema,
    composite_key: [:league_id, :id],
    foreign_key: [:league_id, :conference_id]

  @derive {Phoenix.Param, key: :slug}
  schema "conferences" do
    field :name, :string
    field :abbr, :string
    field :slug, :string

    field :designated_hitter, :boolean, default: false

    belongs_to :league, League
    has_many :divisions, Division

    has_many :teams, Team
  end
end
