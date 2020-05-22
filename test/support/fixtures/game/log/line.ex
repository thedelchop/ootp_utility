defmodule OOTPUtility.Fixtures.Game.Log.Line do
  import Ecto.Changeset, only: [cast: 3, validate_required: 2, apply_changes: 1]

  alias OOTPUtility.Repo
  alias OOTPUtility.Game.Log.Line

  @attrs %{
    game_id: "1",
    type: "3",
    line: "1",
    text: "Foul Ball, location: 2F",
    formatted_text: "2-2: Swinging Strike (Foul Ball, 2F)"
  }

  def create_game_log_line(attrs \\ %{}) do
    attrs
    |> build_line_changeset()
    |> Repo.insert!()
  end

  def build_game_log_line(attrs \\ %{}) do
    attrs
    |> build_line_changeset()
    |> apply_changes()
  end

  defp build_line_changeset(attrs) do
    with line_attrs <- Enum.into(attrs, @attrs) do
      %Line{}
      |> cast(line_attrs, [:game_id, :line, :text, :type, :formatted_text])
      |> validate_required([:game_id, :line, :text, :type, :formatted_text])
      |> Line.update_import_changeset()
    end
  end
end
