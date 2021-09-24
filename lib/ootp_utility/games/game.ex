defmodule OOTPUtility.Games.Game do
  alias OOTPUtility.{Imports, Repo, Utilities}

  use Imports.Schema, from: "games.csv"

  import Ecto.Query, only: [from: 2]

  alias OOTPUtility.Leagues.League
  alias OOTPUtility.Players.Player
  alias OOTPUtility.Teams.Team

  import_schema "games" do
    field :attendance, :integer
    field :away_team_errors, :integer
    field :away_team_hits, :integer
    field :away_team_runs, :integer
    field :date, :date
    field :dh, :boolean, default: false
    field :game_type, :integer
    field :home_team_errors, :integer
    field :home_team_hits, :integer
    field :home_team_runs, :integer
    field :innings, :integer
    field :played, :boolean, default: false
    field :time, :time

    belongs_to :league, League
    belongs_to :home_team, Team
    belongs_to :away_team, Team

    belongs_to :winning_pitcher, Player
    belongs_to :losing_pitcher, Player

    belongs_to :away_team_starter, Player
    belongs_to :home_team_starter, Player
    belongs_to :save_pitcher, Player
  end

  def sanitize_attributes(%{save_pitcher: "0"} = attrs) do
    sanitize_attributes(%{attrs | save_pitcher: nil})
  end

  def sanitize_attributes(%{starter0: "0"} = attrs) do
    sanitize_attributes(%{attrs | starter0: nil})
  end

  def sanitize_attributes(%{starter1: "0"} = attrs) do
    sanitize_attributes(%{attrs | starter1: nil})
  end

  def sanitize_attributes(%{winning_pitcher: "0"} = attrs) do
    sanitize_attributes(%{attrs | winning_pitcher: nil})
  end

  def sanitize_attributes(%{losing_pitcher: "0"} = attrs) do
    sanitize_attributes(%{attrs | losing_pitcher: nil})
  end

  def sanitize_attributes(%{date: original_date, time: original_time} = attrs) do
    with {:ok, date} <- Timex.parse(original_date, "{YYYY}-{M}-{D}"),
         {:ok, time} <- original_time |> String.pad_leading(4, "0") |> Timex.parse("{h24}{m}") do

      attrs
      |> Utilities.rename_keys([
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
      ])
      |> Map.put(:date, NaiveDateTime.to_date(date))
      |> Map.put(:time, NaiveDateTime.to_time(time))
    end
  end

  def valid_for_import?(%{home_team_id: home_team_id, away_team_id: away_team_id}) do
    Repo.exists?(from t in Team, where: t.id == ^home_team_id) and
      Repo.exists?(from t in Team, where: t.id == ^away_team_id)
  end
end
