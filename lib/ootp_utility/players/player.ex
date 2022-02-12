defmodule OOTPUtility.Players.Player do
  alias OOTPUtility.Teams.Team
  alias OOTPUtility.Players.{Morale, Personality}

  @derive {Inspect, only: [:id, :first_name, :last_name, :position, :ability, :talent]}

  use OOTPUtility.Schema

  @derive {Phoenix.Param, key: :slug}
  schema "players" do
    field :first_name, :string
    field :last_name, :string
    field :nickname, :string

    field :slug, :string

    field :height, :integer
    field :weight, :integer

    field :bats, :string
    field :throws, :string

    field :age, :integer
    field :date_of_birth, :date
    field :experience, :integer
    field :retired, :boolean, default: false

    field :local_popularity, :integer
    field :national_popularity, :integer

    field :position, Ecto.Enum,
      values: [
        pitcher: 1,
        catcher: 2,
        first_base: 3,
        second_base: 4,
        third_base: 5,
        shortstop: 6,
        left_field: 7,
        center_field: 8,
        right_field: 9,
        designated_hitter: 10,
        starting_pitcher: 11,
        middle_reliever: 12,
        closer: 13
      ]

    field :uniform_number, :integer

    field :free_agent, :boolean, default: false

    field :groundball_flyball_ratio, Ecto.Enum,
      values: [
        extreme_groundball: 1,
        groundball: 2,
        neutral: 3,
        flyball: 4,
        extreme_flyball: 5
      ]

    field :velocity, Ecto.Enum,
      values: [
        "75-80 MPH": 1,
        "80-83 MPH": 2,
        "83-85 MPH": 3,
        "84-86 MPH": 4,
        "85-87 MPH": 5,
        "86-88 MPH": 6,
        "87-89 MPH": 7,
        "88-90 MPH": 8,
        "89-91 MPH": 9,
        "90-92 MPH": 10,
        "91-93 MPH": 11,
        "92-94 MPH": 12,
        "93-95 MPH": 13,
        "94-96 MPH": 14,
        "95-97 MPH": 15,
        "96-98 MPH": 16,
        "97-99 MPH": 17,
        "98-100 MPH": 18,
        "99-101 MPH": 19,
        "100+ MPH": 20
      ]

    field :arm_slot, Ecto.Enum,
      values: [
        submarine: 1,
        sidearm: 2,
        normal: 3,
        over_the_top: 4
      ]

    field :stamina, :integer
    field :hold_runners, :integer

    field :groundball_hitter_type, :integer
    field :flyball_hitter_type, :integer

    field :ability, :integer
    field :talent, :integer

    belongs_to :organization, Team
    belongs_to :team, Team

    has_one :league, through: [:team, :league]

    has_one :personality, Personality
    has_one :morale, Morale
  end
end
