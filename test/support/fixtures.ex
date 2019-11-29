defmodule OOTPUtility.Fixtures do
  alias OOTPUtility.Game.Log.Line
  alias OOTPUtility.Repo

  require OOTPUtility.Game.Log.Line

  @line_attrs %{
    game_id: "1",
    type: "3",
    line: "1",
    text: "Foul Ball, location: 2F",
    formatted_text: "2-2: Swinging Strike (Foul Ball, 2F)"
  }

  def create_game_log_line(attrs \\ %{}) do
    attributes = 
      attrs 
      |> Enum.into(@line_attrs)
      |> Line.import_changeset()

    Repo.insert(attributes)
    |> elem(1)
  end
end
