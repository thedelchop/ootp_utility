defmodule OOTPUtility.Leagues.Division do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:division_id, :id, autogenerate: false}
  schema "divisions" do
    field :name, :string

    belongs_to :league, OOTPUtility.Leagues.League,
      references: :league_id,
      foreign_key: :league_id

    belongs_to :conference, OOTPUtility.Leagues.Conference,
      references: :conference_id,
      foreign_key: :conference_id

    has_many :teams, OOTPUtility.Leagues.Team, foreign_key: :team_id, references: :division_id
  end

  @doc false
  def changeset(division, attrs) do
    division
    |> cast(attrs, [:division_id, :name, :league_id, :conference_id])
    |> validate_required([:division_id, :name, :league_id, :conference_id])
  end
end
