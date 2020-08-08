defmodule OOTPUtility.Fixtures.Game.Inning do
  @attrs %{
    id: "1-1",
    game_id: 1,
    number: 1
  }

  alias OOTPUtility.Game.Inning

  def create_inning(attrs \\ %{}) do
    %{
      inning_id: inning_id,
      orientation: orientation,
      lines: lines
    } =
      attrs
      |> Enum.into(@attrs)
      |> Map.put_new(:lines, create_inning_lines())

    Inning.new(inning_id, orientation, lines)
  end

  defp create_inning_lines() do
    [
      [
        1,
        1,
        1,
        "Top of the 1st -  Eastern Division All-Stars batting - Pitching for Western Division All-Stars : LHP <a href=\"../players/player_24715.html\">Bryan Sammons</a>"
      ],
      [1, 2, 2, "Pitching: LHP <a href=\"../players/player_24715.html\">Bryan Sammons</a>"],
      [1, 2, 3, "Batting: LHB <a href=\"../players/player_23947.html\">D.J. Wilson</a>"],
      [1, 3, 4, "0-0: Ball"],
      [1, 3, 5, "1-0: Ball"],
      [1, 3, 6, "2-0: Ball"],
      [1, 3, 7, "3-0: Base on Balls"],
      [
        1,
        4,
        29,
        "Top of the 1st over -  0 runs, 1 hit, 0 errors, 2 left on base; Eastern Division 0 - Western Division 0"
      ],
      [
        1,
        1,
        30,
        "Bottom of the 1st -  Western Division All-Stars batting - Pitching for Eastern Division All-Stars : RHP <a href=\"../players/player_36425.html\">Luis Araujo</a>"
      ],
      [1, 2, 31, "Pitching: RHP <a href=\"../players/player_36425.html\">Luis Araujo</a>"],
      [1, 2, 32, "Batting: RHB <a href=\"../players/player_20750.html\">Edwin Figuera</a>"],
      [1, 3, 33, "0-0: Ball"],
      [1, 3, 34, "1-0: Foul Ball, location: 2F"],
      [1, 3, 35, "1-1: Swinging Strike"],
      [1, 3, 36, "1-2: Foul Ball, location: 2F"],
      [1, 3, 37, "1-2: Foul Ball, location: 2F"],
      [1, 3, 38, "1-2: Strikes out  swinging"],
      [
        1,
        4,
        61,
        "Bottom of the 1st over -  1 run, 2 hits, 1 error, 2 left on base; Eastern Division 0 - Western Division 1"
      ]
    ]
  end
end
