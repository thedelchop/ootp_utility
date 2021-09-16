defmodule OOTPUtility.Leagues.Conference do
  @type t() :: %__MODULE__{}

  alias OOTPUtility.{Imports, Schema, Utilities}
  alias OOTPUtility.Leagues.{Division, League}
  alias OOTPUtility.Teams.Team

  use Schema,
    composite_key: [:league_id, :id],
    foreign_key: [:league_id, :conference_id]

  use Imports,
    attributes: [
      :id,
      :name,
      :abbr,
      :designated_hitter,
      :league_id
    ],
    from: "sub_leagues.csv"

  schema "conferences" do
    field :abbr, :string
    field :designated_hitter, :boolean, default: false
    field :name, :string

    belongs_to :league, League
    has_many :divisions, Division

    has_many :teams, Team
  end

  def update_import_changeset(changeset), do: put_composite_key(changeset)

  def sanitize_attributes(attrs),
    do: Utilities.rename_keys(attrs, [{:sub_league_id, :id}])
end
