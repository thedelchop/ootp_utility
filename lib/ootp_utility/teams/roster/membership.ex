defmodule OOTPUtility.Teams.Roster.Membership do
  alias OOTPUtility.Teams.Team
  alias OOTPUtility.Players.Player

  @derive {Inspect,
           only: [
             :team,
             :player,
             :type
           ]}

  use OOTPUtility.Schema,
    composite_key: [:team_id, :type, :player_id]

  schema "team_rosters_membership" do
    field :type, Ecto.Enum, values: [:preseason, :active, :expanded, :injured]

    belongs_to :team, Team
    belongs_to :player, Player
  end
end
