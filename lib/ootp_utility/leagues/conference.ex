defmodule OOTPUtility.Leagues.Conference do
  use OOTPUtility.Schema, composite_key: [:league_id, :conference_id]
  use OOTPUtility.Imports

  alias OOTPUtility.{League, Team}
  alias OOTPUtility.Leagues.Division

  attributes_to_import([:id, :name, :abbr, :designated_hitter, :league_id])

  schema "conferences" do
    field :name, :string
    field :abbr, :string
    field :designated_hitter, :boolean, default: false

    belongs_to :league, League

    has_many :divisions, Division
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
    |> Map.delete(:sub_league_id)
  end

  defp build_association_ids(attrs) do
    attrs
    |> Map.put(:id, generate_composite_key(attrs))
    |> Map.delete(:conference_id)
  end
end
