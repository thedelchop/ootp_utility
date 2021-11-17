defmodule OOTPUtility.Standings.TeamRecord do
  alias OOTPUtility.Teams.Team

  @derive {Inspect,
           only: [
             :id,
             :team,
             :games,
             :wins,
             :losses,
             :winning_percentage,
             :position,
             :games_behind
           ]}

  use OOTPUtility.Schema,
    composite_key: [:team_id]

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
end
