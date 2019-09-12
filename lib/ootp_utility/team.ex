defmodule OOTPUtility.Team do
  use OOTPUtility.Schema

  alias OOTPUtility.{League}
  alias OOTPUtility.Leagues.{Conference, Division}
  alias OOTPUtility.World.City

  @primary_key {:team_id, :id, autogenerate: false}
  schema "teams" do
    field :abbr, :string
    field :level, :string
    field :logo_filename, :string
    field :name, :string

    belongs_to :city, City, references: :city_id, foreign_key: :city_id

    belongs_to :league, League

    belongs_to :conference, Conference

    belongs_to :division, Division
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [
      :team_id,
      :abbr,
      :name,
      :logo_filename,
      :level,
      :city_id,
      :league_id,
      :conference_id,
      :division_id
    ])
    |> validate_required([
      :team_id,
      :abbr,
      :name,
      :logo_filename,
      :level,
      :city_id,
      :league_id,
      :conference_id,
      :division_id
    ])
  end
end
