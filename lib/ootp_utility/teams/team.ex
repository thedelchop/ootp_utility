defmodule OOTPUtility.Teams.Team do
  alias OOTPUtility.{Schema, Standings}
  alias OOTPUtility.Leagues.{Conference, Division, League}
  alias OOTPUtility.Teams.Affiliation

  @derive {Inspect,
           only: [
             :id,
             :name,
             :level,
             :league,
             :record,
             :affiliates,
             :organization
           ]}

  use Schema

  @derive {Phoenix.Param, key: :slug}
  schema "teams" do
    field :name, :string
    field :nickname, :string
    field :abbr, :string
    field :slug, :string

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

    belongs_to :league, League
    belongs_to :conference, Conference
    belongs_to :division, Division

    has_one :record, Standings.TeamRecord

    has_many :affiliations, Affiliation

    has_many :affiliates, through: [:affiliations, :affiliate]
    has_one :organization, through: [:affiliations, :team], foreign_key: :affilate_id
  end
end
