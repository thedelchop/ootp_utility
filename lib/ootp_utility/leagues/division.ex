defmodule OOTPUtility.Leagues.Division do
  alias OOTPUtility.Leagues.{Conference, League}
  alias OOTPUtility.Teams.Team

  use OOTPUtility.Schema,
    composite_key: [:league_id, :conference_id, :id],
    foreign_key: [:league_id, :conference_id, :division_id]

  @derive {Phoenix.Param, key: :slug}
  schema "divisions" do
    field :name, :string
    field :slug, :string

    belongs_to :league, League
    belongs_to :conference, Conference

    has_many :teams, Team
  end
end
