defmodule OOTPUtility.Leagues.Division do
  use OOTPUtility.Schema, composite_key: [:league_id, :conference_id, :division_id]

  alias OOTPUtility.{League, Team}
  alias OOTPUtility.Leagues.Conference

  schema "divisions" do
    field :name, :string

    belongs_to :league, League
    belongs_to :conference, Conference
    has_many :teams, Team
  end

  @doc false
  def changeset(division, attrs) do
    division
    |> cast(attrs, [:division_id, :name, :league_id, :conference_id])
    |> validate_required([:division_id, :name, :league_id, :conference_id])
  end
end
