defmodule OOTPUtility.Players.Player do
  alias OOTPUtility.Teams.Team
  alias OOTPUtility.Leagues.League

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

    field :bats, :integer
    field :throws, :integer

    field :age, :integer
    field :date_of_birth, :string
    field :experience, :integer
    field :retired, :boolean, default: false

    field :local_popularity, :integer
    field :national_popularity, :integer

    field :position, :integer
    field :uniform_number, :integer
    field :role, :integer

    field :free_agent, :boolean, default: false

    belongs_to :league, League
    belongs_to :organization, Team
    belongs_to :team, Team
  end
end
