defmodule OOTPUtility.Team.Record do
  use OOTPUtility.Schema

  use OOTPUtility.Imports,
    attributes: [
      :id,
      :games,
      :wins,
      :losses,
      :position,
      :winning_percentage,
      :games_behind,
      :streak,
      :magic_number,
      :team_id
    ],
    from: "team_record.csv"

  alias OOTPUtility.Team

  schema "team_records" do
    field :games, :integer
    field :games_behind, :float
    field :losses, :integer
    field :magic_number, :integer
    field :position, :integer
    field :streak, :integer
    field :winning_percentage, :float
    field :wins, :integer

    belongs_to :team, Team
  end

  def sanitize_attributes(attrs) do
    attrs
    |> Map.put(:id, Map.get(attrs, :team_id))
    |> Map.put(:games_behind, Map.get(attrs, :gb))
    |> Map.put(:losses, Map.get(attrs, :l))
    |> Map.put(:wins, Map.get(attrs, :w))
    |> Map.put(:winning_percentage, Map.get(attrs, :pct))
    |> Map.put(:games, Map.get(attrs, :g))
    |> Map.put(:position, Map.get(attrs, :pos))
  end
end
