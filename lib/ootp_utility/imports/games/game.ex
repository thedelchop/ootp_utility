defmodule OOTPUtility.Imports.Games.Game do
  alias OOTPUtility.{Repo, Teams, Players}

  import Ecto.Query, only: [from: 2]

  use OOTPUtility.Imports,
    from: "games.csv",
    headers: [
      {:game_id, :id},
      {:home_team, :home_team_id},
      {:away_team, :away_team_id},
      {:runs0, :away_team_runs},
      {:runs1, :home_team_runs},
      {:hits0, :away_team_hits},
      {:hits1, :home_team_hits},
      {:errors0, :away_team_errors},
      {:errors1, :home_team_errors},
      {:winning_pitcher, :winning_pitcher_id},
      {:losing_pitcher, :losing_pitcher_id},
      {:starter0, :away_team_starter_id},
      {:starter1, :home_team_starter_id},
      {:save_pitcher, :save_pitcher_id}
    ],
    schema: OOTPUtility.Games.Game

  def sanitize_attributes(%{save_pitcher_id: "0"} = attrs) do
    sanitize_attributes(%{attrs | save_pitcher_id: nil})
  end

  def sanitize_attributes(%{away_team_starter_id: "0"} = attrs) do
    sanitize_attributes(%{attrs | away_team_starter_id: nil})
  end

  def sanitize_attributes(%{home_team_starter_id: "0"} = attrs) do
    sanitize_attributes(%{attrs | home_team_starter_id: nil})
  end

  def sanitize_attributes(%{winning_pitcher_id: "0"} = attrs) do
    sanitize_attributes(%{attrs | winning_pitcher_id: nil})
  end

  def sanitize_attributes(%{losing_pitcher_id: "0"} = attrs) do
    sanitize_attributes(%{attrs | losing_pitcher_id: nil})
  end

  def sanitize_attributes(%{date: original_date, time: original_time} = attrs) do
    with {:ok, date} <- Timex.parse(original_date, "{YYYY}-{M}-{D}"),
         {:ok, time} <- original_time |> String.pad_leading(4, "0") |> Timex.parse("{h24}{m}") do
      attrs
      |> Map.put(:date, NaiveDateTime.to_date(date))
      |> Map.put(:time, NaiveDateTime.to_time(time))
    end
  end

  def validate_changeset(%Ecto.Changeset{changes: changes} = _c)
      when is_map_key(changes, :played) do
    home_team_id = Map.get(changes, :home_team_id)
    away_team_id = Map.get(changes, :away_team_id)
    home_team_starter_id = Map.get(changes, :home_team_starter_id)
    away_team_starter_id = Map.get(changes, :away_team_starter_id)
    winning_pitcher_id = Map.get(changes, :winning_pitcher_id)
    losing_pitcher_id = Map.get(changes, :losing_pitcher_id)
    save_pitcher_id = Map.get(changes, :save_pitcher_id)

    teams_and_starters_exist =
      Repo.exists?(from t in Teams.Team, where: t.id == ^home_team_id) &&
        Repo.exists?(from t in Teams.Team, where: t.id == ^away_team_id) &&
        Repo.exists?(from p in Players.Player, where: p.id == ^home_team_starter_id) &&
        Repo.exists?(from p in Players.Player, where: p.id == ^away_team_starter_id) &&
        Repo.exists?(from p in Players.Player, where: p.id == ^losing_pitcher_id) &&
        Repo.exists?(from p in Players.Player, where: p.id == ^winning_pitcher_id)

    if Map.has_key?(changes, :save_pitcher_id) do
      teams_and_starters_exist &&
        Repo.exists?(from p in Players.Player, where: p.id == ^save_pitcher_id)
    else
      teams_and_starters_exist
    end
  end

  def validate_changeset(%Ecto.Changeset{changes: changes}) do
    home_team_id = Map.get(changes, :home_team_id)
    away_team_id = Map.get(changes, :away_team_id)

    Repo.exists?(from t in Teams.Team, where: t.id == ^home_team_id) &&
      Repo.exists?(from t in Teams.Team, where: t.id == ^away_team_id)
  end
end
