defmodule OOTPUtility.Players.Player do
  @moduledoc """

    Here is the conversion of ability/potential ratings to stars

    | Stars | Min | Max |
    | ----- | --- | --- |
    | 5     | 78  | 80  |
    | 4.5   | 72  | 77  |
    | 4     | 65  | 71  |
    | 3.5   | 59  | 64  |
    | 3     | 51  | 58  |
    | 2.5   | 43  | 50  |
    | 2     | 35  | 42  |
    | 1.5   | 25  | 34  |
    | 1     | 21  | 24  |
    | 0.5   | 20  | 20  |
  """

  alias OOTPUtility.Teams.Team
  alias OOTPUtility.Players.{Morale, Personality}

  @derive {Inspect, only: [:id, :first_name, :last_name, :position, :role, :team]}

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

    field :ability, :integer
    field :talent, :integer

    belongs_to :organization, Team
    belongs_to :team, Team

    has_one :league, through: [:team, :league]

    has_one :personality, Personality
    has_one :morale, Morale
  end
end
