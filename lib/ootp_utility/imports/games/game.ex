defmodule OOTPUtility.Imports.Games.Game do
  alias OOTPUtility.Imports

  use OOTPUtility.Imports,
    from: "games",
    headers: [
      {:game_id, :id},
      {:game_type, :type},
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
    schema: OOTPUtility.Games.Game,
    cache: true

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

  def validate_changeset(%Ecto.Changeset{changes: changes} = changeset)
      when is_map_key(changes, :played) do
    teams_exist?(changeset) && players_exist?(changeset)
  end

  def validate_changeset(%Ecto.Changeset{} = changeset), do: teams_exist?(changeset)

  defp teams_exist?(%Ecto.Changeset{changes: changes}) do
    team_keys = [:home_team_id, :away_team_id]

    changes
    |> Map.take(team_keys)
    |> Map.values()
    |> Enum.all?(&Imports.ImportAgent.in_cache?(:teams, &1))
  end

  defp players_exist?(%Ecto.Changeset{changes: changes}) do
    player_keys = [
      :home_team_starter_id,
      :away_team_starter_id,
      :winning_pitcher_id,
      :losing_pitcher_id,
      :save_pitcher_id
    ]

    changes
    |> Map.take(player_keys)
    |> Map.values()
    |> Enum.all?(&Imports.ImportAgent.in_cache?(:players, &1))
  end
end
