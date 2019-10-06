defmodule OOTPUtility.Team.Record do
  use OOTPUtility.Schema
  use OOTPUtility.Imports

  alias OOTPUtility.Team

  imports(
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
  )

  schema "team_records" do
    field :games, :integer
    field :games_behind, :float
    field :losses, :integer
    field :magic_number, :integer
    field :position, :integer
    field :streak, :integer
    field :winning_percentage, :float
    field :wins, :integer
    field :game_date, :date

    belongs_to :team, Team
  end

  def sanitize_attributes(attrs) do
    attrs
    |> Map.put(:id, Map.get(attrs, :team_id))
  end
end
