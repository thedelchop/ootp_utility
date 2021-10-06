defmodule OOTPUtility.Leagues.Conference do
  alias OOTPUtility.Leagues.{Division, League}
  alias OOTPUtility.Teams.Team

  use OOTPUtility.Schema,
    composite_key: [:league_id, :id],
    foreign_key: [:league_id, :conference_id]

  schema "conferences" do
    field :abbr, :string
    field :designated_hitter, :boolean, default: false
    field :name, :string

    belongs_to :league, League
    has_many :divisions, Division

    has_many :teams, Team
  end
end
