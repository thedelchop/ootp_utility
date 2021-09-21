defmodule OOTPUtility.Players.Player do
  @type t() :: %__MODULE__{}
  alias OOTPUtility.{Imports, Schema, Utilities}
  alias OOTPUtility.Teams.Team
  alias OOTPUtility.Leagues.League

  use Schema

  use Imports,
    attributes: [
      :id,
      :team_id,
      :league_id,
      :organization_id,
      :first_name,
      :last_name,
      :nickname,
      :weight,
      :height,
      :age,
      :date_of_birth,
      :experience,
      :uniform_number,
      :bats,
      :throws,
      :position,
      :role,
      :free_agent,
      :retired,
      :local_popularity,
      :national_popularity
    ],
    from: "players.csv"

  schema "players" do
    field :age, :integer
    field :bats, :integer
    field :date_of_birth, :string
    field :experience, :integer
    field :first_name, :string
    field :free_agent, :boolean, default: false
    field :height, :integer
    field :last_name, :string
    field :local_popularity, :integer
    field :national_popularity, :integer
    field :nickname, :string
    field :position, :integer
    field :retired, :boolean, default: false
    field :role, :integer
    field :throws, :integer
    field :uniform_number, :integer
    field :weight, :integer

    belongs_to :league, League
    belongs_to :organization, Team
    belongs_to :team, Team
  end

  def should_import_from_csv?(%{retired: "1"} = _attrs), do: false
  def should_import_from_csv?(_attrs), do: true

  def sanitize_attributes(attrs),
    do:
      Utilities.rename_keys(attrs, [
        {:player_id, :id},
        {:local_pop, :local_popularity},
        {:national_pop, :national_popularity}
      ])
end
