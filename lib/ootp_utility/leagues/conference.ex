defmodule OOTPUtility.Leagues.Conference do
  alias OOTPUtility.{Imports, Utilities}
  alias OOTPUtility.Leagues.{Division, League}
  alias OOTPUtility.Teams.Team

  use Imports.Schema,
    from: "sub_leagues.csv",
    composite_key: [:league_id, :id],
    foreign_key: [:league_id, :conference_id]

  import_schema "conferences" do
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
