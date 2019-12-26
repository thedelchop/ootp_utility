defmodule OOTPUtility.Fixtures do
  alias OOTPUtility.Game.Log.Line
  alias OOTPUtility.Repo
  import Ecto.Changeset, only: [cast: 3, validate_required: 2]

  @line_attrs %{
    game_id: "1",
    type: "3",
    line: "1",
    text: "Foul Ball, location: 2F",
    formatted_text: "2-2: Swinging Strike (Foul Ball, 2F)"
  }

  def create_game_log_line(attrs \\ %{}) do
    attrs
    |> Enum.into(@line_attrs)
    |> line_changeset()
    |> Repo.insert()
    |> elem(1)
  end

  defp line_changeset(attrs) do
    %Line{}
    |> cast(attrs, [:id, :game_id, :line, :text, :type, :formatted_text])
    |> validate_required([:id, :game_id, :line, :text, :type, :formatted_text])
    |> Line.update_import_changeset()
  end
end
