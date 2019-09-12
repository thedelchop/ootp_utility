defmodule OOTPUtility.Leagues.Conference do
  use OOTPUtility.Schema, composite_key: [:league_id, :conference_id]

  alias OOTPUtility.{League, Team}
  alias OOTPUtility.Leagues.Division

  schema "conferences" do
    field :name, :string
    field :abbr, :string
    field :designated_hitter, :boolean, default: false

    belongs_to :league, League

    has_many :divisions, Division
    has_many :teams, Team
  end

  @doc false
  def changeset(conference, attrs) do
    conference
    |> cast(attrs, [:sub_league_id, :name, :abbr, :designated_hitter, :league_id])
    |> validate_required([:sub_league_id, :name, :abbr, :designated_hitter, :league_id])
  end
end
