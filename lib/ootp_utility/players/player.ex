defmodule OOTPUtility.Players.Player do
  alias OOTPUtility.Teams.Team

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

    field :position, Ecto.Enum, values: [
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

    belongs_to :organization, Team
    belongs_to :team, Team

    has_one :league, through: [:team, :league]
  end
end
