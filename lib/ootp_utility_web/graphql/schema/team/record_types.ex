defmodule OOTPUtility.Schema.Team.RecordTypes do
  use Absinthe.Schema.Notation

  object :team_record do
    field :id, :id
    field :games, :integer
    field :games_behind, :float
    field :losses, :integer
    field :magic_number, :integer
    field :position, :integer
    field :streak, :integer
    field :winning_percentage, :float
    field :wins, :integer
  end
end
