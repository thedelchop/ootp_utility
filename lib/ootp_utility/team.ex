defmodule OOTPUtility.Team do
  use OOTPUtility.Schema

  use OOTPUtility.Imports,
    attributes: [
      :id,
      :abbr,
      :name,
      :logo_filename,
      :level,
      :city_id,
      :league_id,
      :conference_id,
      :division_id
    ],
    from: "teams.csv"

  alias OOTPUtility.{League}
  alias OOTPUtility.Leagues.{Conference, Division}
  alias OOTPUtility.World.City

  schema "teams" do
    field :abbr, :string
    field :level, :string
    field :logo_filename, :string
    field :name, :string

    belongs_to :city, City

    belongs_to :league, League

    belongs_to :conference, Conference

    belongs_to :division, Division
  end

  @impl OOTPUtility.Imports
  def sanitize_attributes(attrs) do
    attrs
    |> map_import_attributes_to_schema
    |> build_association_ids
  end

  defp map_import_attributes_to_schema(attrs) do
    attrs
    |> Map.put(:id, Map.get(attrs, :team_id))
    |> Map.put(:conference_id, Map.get(attrs, :sub_league_id))
    |> Map.put(:city_id, nil)
    |> Map.delete(:team_id)
    |> Map.delete(:sub_league_id)
  end

  defp build_association_ids(attrs) do
    attrs
    |> Map.put(:division_id, Division.generate_composite_key(attrs))
    |> Map.put(:conference_id, Conference.generate_composite_key(attrs))
  end
end
