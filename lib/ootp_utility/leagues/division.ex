defmodule OOTPUtility.Leagues.Division do
  use OOTPUtility.Schema, composite_key: [:league_id, :conference_id, :division_id]

  use OOTPUtility.Imports,
    attributes: [:id, :name, :league_id, :conference_id],
    from: "divisions.csv"

  alias OOTPUtility.{League, Team}
  alias OOTPUtility.Leagues.Conference

  schema "divisions" do
    field :name, :string
    belongs_to :league, League
    belongs_to :conference, Conference
    has_many :teams, Team
  end

  @impl OOTPUtility.Imports
  def sanitize_attributes(attrs) do
    attrs
    |> map_import_attributes_to_schema
    |> build_association_ids
  end

  defp map_import_attributes_to_schema(attrs) do
    attrs
    |> Map.put(:conference_id, Map.get(attrs, :sub_league_id))
  end

  defp build_association_ids(attrs) do
    attrs
    |> Map.put(:id, generate_composite_key(attrs))
    |> Map.put(:conference_id, Conference.generate_composite_key(attrs))
    |> Map.delete(:division_id)
    |> Map.delete(:sub_league_id)
  end
end
