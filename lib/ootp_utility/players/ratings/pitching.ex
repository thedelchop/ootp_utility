defmodule OOTPUtility.Players.Ratings.Pitching do
  use OOTPUtility.Schema

  alias OOTPUtility.Players.Player

  @primary_key false
  schema "players_pitching_ratings" do
    field :type, Ecto.Enum,
      values: [ability: 1, ability_vs_left: 2, ability_vs_right: 3, talent: 4]

    field :stuff, :integer
    field :control, :integer
    field :movement, :integer

    field :groundball_flyball_ratio, Ecto.Enum,
      values: [
        extreme_groundball: 1,
        groundball: 2,
        neutral: 3,
        flyball: 4,
        extreme_flyball: 5
      ]

    field :velocity, Ecto.Enum,
      values: [
        "75-80 MPH": 1,
        "80-83 MPH": 2,
        "83-85 MPH": 3,
        "84-86 MPH": 4,
        "85-87 MPH": 5,
        "86-88 MPH": 6,
        "87-89 MPH": 7,
        "88-90 MPH": 8,
        "89-91 MPH": 9,
        "90-92 MPH": 10,
        "91-93 MPH": 11,
        "92-94 MPH": 12,
        "93-95 MPH": 13,
        "94-96 MPH": 14,
        "95-97 MPH": 15,
        "96-98 MPH": 16,
        "97-99 MPH": 17,
        "98-100 MPH": 18,
        "99-101 MPH": 19,
        "100+ MPH": 20
      ]

    field :arm_slot, Ecto.Enum,
      values: [
        submarine: 1,
        sidearm: 2,
        normal: 3,
        over_the_top: 4
      ]

    field :stamina, :integer
    field :hold_runners, :integer

    belongs_to :player, Player
  end
end
