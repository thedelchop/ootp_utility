defmodule OOTPUtility.Leagues.Conference do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:conference_id, :id, autogenerate: false}
  schema "conferences" do
    field :abbr, :string
    field :designated_hitter, :boolean, default: false
    field :name, :string

    belongs_to :league, OOTPUtility.Leagues.League,
      references: :league_id,
      foreign_key: :league_id

    has_many :divisions, OOTPUtility.Leagues.Division,
      foreign_key: :division_id,
      references: :conference_id

    has_many :teams, OOTPUtility.Team, foreign_key: :team_id, references: :conference_id
  end

  @doc false
  def changeset(conference, attrs) do
    conference
    |> cast(attrs, [:sub_league_id, :name, :abbr, :designated_hitter, :league_id])
    |> validate_required([:sub_league_id, :name, :abbr, :designated_hitter, :league_id])
  end
end
