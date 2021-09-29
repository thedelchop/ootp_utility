defmodule OOTPUtility.Players.Player do
  alias OOTPUtility.{Imports, Utilities}
  alias OOTPUtility.Teams.Team
  alias OOTPUtility.Leagues.League

  use Imports.Schema, from: "players.csv"

  import_schema "players" do
    field :first_name, :string
    field :last_name, :string
    field :nickname, :string

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

  def should_import_from_csv?(%{retired: "1"} = _attrs), do: false
  def should_import_from_csv?(_attrs), do: true

  def sanitize_attributes(%{team_id: "0"} = attrs) do
    sanitize_attributes(%{attrs | team_id: nil})
  end

  def sanitize_attributes(%{organization_id: "0"} = attrs) do
    sanitize_attributes(%{attrs | organization_id: nil})
  end

  def sanitize_attributes(%{league_id: league_id} = attrs) do
    attrs = if String.to_integer(league_id) < 1, do: %{attrs | league_id: nil}, else: attrs

    attrs
    |> Utilities.rename_keys([
      {:player_id, :id},
      {:local_pop, :local_popularity},
      {:national_pop, :national_popularity}
    ])
  end
end
