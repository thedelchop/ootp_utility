defmodule OOTPUtility.Team.Record do
  use Ecto.Schema
  import Ecto.Changeset

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

    belongs_to :team, OOTPUtility.Leagues.Team, foreign_key: :team_id, references: :team_id

    timestamps()
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [
      :games,
      :wins,
      :losses,
      :position,
      :winning_percentage,
      :games_behind,
      :streak,
      :magic_number,
      :team_id
    ])
    |> validate_required([
      :games,
      :wins,
      :losses,
      :position,
      :winning_percentage,
      :games_behind,
      :streak,
      :magic_number,
      :team_id
    ])
  end
end
