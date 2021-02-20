defmodule OOTPUtility.Fixtures.Game.Log.Line do
  import Ecto.Changeset, only: [cast: 3, validate_required: 2, apply_changes: 1]

  alias OOTPUtility.Repo
  alias OOTPUtility.Imports.GameLog.Line

  @attrs %{
    game_id: "1",
    type: "3",
    line: "1",
    text: "Foul Ball, location: 2F"
  }

  @spec create_game_log_line(map()) :: Line.t()
  def create_game_log_line(attrs \\ %{}) do
    attrs
    |> build_line_changeset()
    |> Repo.insert!()
  end

  @spec build_game_log_line(map()) :: Line.t()
  def build_game_log_line(attrs \\ %{}) do
    attrs
    |> build_line_changeset()
    |> apply_changes()
  end

  @spec lines_for_inning(number, number, keyword(atom())) ::
          {[Line.t()], {[Line.t()], [Line.t()]}} | [Line.t()]
  def lines_for_inning(game, inning, [{:as, scope}] \\ [{:as, :inning}]) do
    top_frame_lines = lines_for_frame(game, inning, :top)

    bottom_frame_lines = lines_for_frame(game, inning, :bottom)

    inning_lines = top_frame_lines ++ bottom_frame_lines

    case scope do
      :frames -> {inning_lines, {top_frame_lines, bottom_frame_lines}}
      :inning -> inning_lines
    end
  end

  @spec lines_for_inning(number, number, :top | :bottom) :: [Line.t()]
  def lines_for_frame(game, inning, frame) do
    human_frame =
      "#{frame |> Atom.to_string() |> String.capitalize()} of the #{
        Number.Human.number_to_ordinal(inning)
      }"

    [
      [game, 1, 1, "#{human_frame} - A batting - Pitching for B : LHP John Doe"],
      [game, 2, 2, "Pitching: LHP John Doe"],
      [game, 2, 3, "Batting: LHB Joe Schmoe"],
      [game, 3, 4, "0-0: Ground out 1-3 (Groundball, 34S, EV 66.2 MPH)"],
      [game, 2, 5, "Batting: SHB Bob Smith"],
      [game, 3, 6, "0-0: Ground out 1-3 (Groundball, 34S, EV 66.2 MPH)"],
      [game, 2, 7, "Batting: RHB Steve Jones"],
      [game, 3, 8, "0-0: Ground out 1-3 (Groundball, 34S, EV 66.2 MPH)"],
      [game, 4, 9, "#{human_frame} over -  0 runs, 0 hit, 0 errors, 0 left on base; A 0 - B 0"]
    ]
    |> Enum.map(&build_game_log_line/1)
  end

  defp build_line_changeset([game_id, type, line, text]),
    do: build_line_changeset(%{game_id: game_id, type: type, line: line, text: text})

  defp build_line_changeset(attrs) when is_map(attrs) do
    with line_attrs <- Enum.into(attrs, @attrs) do
      %Line{}
      |> cast(line_attrs, [:game_id, :line, :text, :type])
      |> validate_required([:game_id, :line, :text, :type])
      |> Line.update_import_changeset()


    end
  end
end
