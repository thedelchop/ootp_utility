defmodule OOTPUtility.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OOTPUtility.Games` context.
  """

  import Ecto.Changeset
  import OOTPUtility.PlayersFixtures
  import OOTPUtility.LeaguesFixtures
  import OOTPUtility.TeamsFixtures
  import OOTPUtility.Fixtures.Utilities

  alias OOTPUtility.Repo
  alias OOTPUtility.Games.Game

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    league = Map.get(attrs, :league, league_fixture())

    home_team = Map.get(attrs, :home_team, team_fixture(%{}, league))
    away_team = Map.get(attrs, :away_team, team_fixture(%{}, league))

    home_team_starter = player_fixture(%{}, home_team)
    away_team_starter = player_fixture(%{}, away_team)
    save_pitcher = player_fixture(%{}, home_team)

    {:ok, game} =
      attrs
      |> Enum.into(%{
        id: generate_id(),
        attendance: 42,
        away_team_errors: 42,
        away_team_hits: 42,
        away_team_runs: 42,
        date: ~D[2021-09-22],
        dh: true,
        game_type: 42,
        home_team_errors: 42,
        home_team_hits: 42,
        home_team_runs: 42,
        innings: 42,
        played: true,
        time: ~T[14:00:00],
        league_id: league.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        winning_pitcher_id: home_team_starter.id,
        losing_pitcher_id: away_team_starter.id,
        away_team_starter_id: away_team_starter.id,
        home_team_starter_id: home_team_starter.id,
        save_pitcher_id: save_pitcher.id
      })
      |> create_game()

    game
  end

  defp create_game(attrs) do
      %Game{}
      |> cast(attrs, [
        :id,
        :attendance,
        :date,
        :time,
        :game_type,
        :played,
        :dh,
        :innings,
        :away_team_runs,
        :home_team_runs,
        :away_team_hits,
        :home_team_hits,
        :away_team_errors,
        :home_team_errors,
        :away_team_id,
        :home_team_id,
        :winning_pitcher_id,
        :losing_pitcher_id,
        :away_team_starter_id,
        :home_team_starter_id,
        :save_pitcher_id
      ])
      |> validate_required([
        :id,
        :attendance,
        :date,
        :time,
        :game_type,
        :played,
        :dh,
        :innings,
        :away_team_runs,
        :home_team_runs,
        :away_team_hits,
        :home_team_hits,
        :away_team_errors,
        :home_team_errors,
        :winning_pitcher_id,
        :losing_pitcher_id,
        :away_team_starter_id,
        :home_team_starter_id,
        :save_pitcher_id
      ])
      |> foreign_key_constraint(:league_id)
      |> foreign_key_constraint(:home_team_id)
      |> foreign_key_constraint(:away_team_id)
      |> foreign_key_constraint(:winning_pitcher_id)
      |> foreign_key_constraint(:losing_pitcher_id)
      |> foreign_key_constraint(:home_team_starter_id)
      |> foreign_key_constraint(:away_team_start_id)
      |> foreign_key_constraint(:save_pitcher_id)
      |> Repo.insert()
  end
end
