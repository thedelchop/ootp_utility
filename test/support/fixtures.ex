defmodule OOTPUtility.Fixtures do
  alias OOTPUtility.Game.Log.Line
  alias OOTPUtility.Repo

  @line_attrs %{
    game_id: 1,
    type: 3,
    line: 1,
    raw_text: "Foul Ball, location: 2F",
    formatted_text: "2-2: Swinging Strike (Foul Ball, 2F)"
  }

  def create_game_log_line(attrs \\ %{}) do
    attributes = attrs |> Enum.into(@line_attrs)

    {:ok, game_log_line} = 
      %Line{}
      |> Line.changeset(attributes)
      |> Repo.insert()

    game_log_line
  end
end
