defmodule OOTPUtility.Leagues.Conference do
  use OOTPUtility.Schema,
    composite_key: [:league_id, :id],
    foreign_key: [:league_id, :conference_id]

  use OOTPUtility.Imports,
    attributes: [:id, :name, :abbr, :designated_hitter, :league_id],
    from: "sub_leagues.csv"

  alias OOTPUtility.{League, Team, Utilities}
  alias OOTPUtility.Leagues.Division

  schema "conferences" do
    field :name, :string
    field :abbr, :string
    field :designated_hitter, :boolean, default: false

    belongs_to :league, League

    has_many :divisions, Division
    has_many :teams, Team
  end

  @impl OOTPUtility.Imports
  def update_import_changeset(changeset), do: put_composite_key(changeset)

  @impl OOTPUtility.Imports
  def sanitize_attributes(attrs),
    do: Utilities.rename_keys(attrs, [{:sub_league_id, :id}])
end
