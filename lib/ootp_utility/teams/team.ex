defmodule OOTPUtility.Teams.Team do
  alias OOTPUtility.{Schema, Standings}
  alias OOTPUtility.Leagues.{Conference, Division, League}
  alias OOTPUtility.Teams.Affiliation

  use Schema

  schema "teams" do
    field :abbr, :string
    field :level, :string
    field :logo_filename, :string
    field :name, :string

    belongs_to :league, League
    belongs_to :conference, Conference
    belongs_to :division, Division

    has_one :record, Standings.TeamRecord

    has_many :affiliations, Affiliation

    has_many :affiliates, through: [:affiliations, :affiliate]
    has_one :organization, through: [:affiliations, :team], foreign_key: :affilate_id
  end
end
