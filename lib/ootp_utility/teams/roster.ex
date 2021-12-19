defmodule OOTPUtility.Teams.Roster do
  @moduledoc """
    A module that represents one of the player rosters that each team is associated with.

    This breaks down into four rosters:

    1) Active - The roster of players who are eligible to play in games
    2) Expanded - The roster of players who are eligible to be added to the active roster
    3) Pre-season - The expanded roster that teams use for preseason play (Spring Traing in MLB)
    4) Injured - The roster of players currently injured

    Teams.Roster is an embedded schema, all of the required data is stored in the database in a join table of team, player and roster type.

    iex> %Teams.Roster{
            name: :active,
            team: %Teams.Team{},
            players: [%Players.Player{}]
          }
  """
  alias OOTPUtility.Teams.Team
  alias OOTPUtility.Players.Player

  @type roster_type :: :preseason | :active | :expanded | :injured

  @derive {Inspect,
           only: [
             :team,
             :players,
             :type
           ]}

  use OOTPUtility.Schema,
    composite_key: [:team_id, :type, :player_id]

  embedded_schema do
    field :type, Ecto.Enum, values: [:preseason, :active, :expanded, :injured]

    embeds_one :team, Team
    embeds_many :players, Player
  end
end
