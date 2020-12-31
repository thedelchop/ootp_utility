defmodule OOTPUtility.Imports.Team.Record do
  use OOTPUtility.Schema

  @type t() :: %__MODULE__{}

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

  alias OOTPUtility.Utilities

  schema "team_records" do
    field :games, :integer
    field :games_behind, :float
    field :losses, :integer
    field :magic_number, :integer
    field :position, :integer
    field :streak, :integer
    field :winning_percentage, :float
    field :wins, :integer

    field :team_id, :string
  end

  def sanitize_attributes(%{} = attrs) do
    attrs
    |> Utilities.rename_keys([
      {:team_id, :id},
      {:gb, :games_behind},
      {:l, :losses},
      {:w, :wins},
      {:winning_percentage, :pct},
      {:games, :g},
      {:position, :pos}
    ])
  end
end
