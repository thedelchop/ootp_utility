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

    belongs_to :league, League,
      references: :league_id,
      foreign_key: :league_id

    belongs_to :conference, Conference,
      references: :conference_id,
      foreign_key: :conference_id

    belongs_to :division, Division,
      references: :division_id,
      foreign_key: :division_id
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
