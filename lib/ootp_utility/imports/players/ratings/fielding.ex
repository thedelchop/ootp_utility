defmodule OOTPUtility.Imports.Players.Ratings.Fielding do
  alias OOTPUtility.{Imports, Players}

  use Imports,
    from: "players_fielding",
    schema: Players.Ratings.Fielding

  def sanitize_attributes(
        %{
          fielding_ratings_infield_range: infield_range,
          fielding_ratings_infield_arm: infield_arm,
          fielding_ratings_infield_error: infield_error,
          fielding_ratings_turn_doubleplay: turn_double_play,
          fielding_ratings_outfield_range: outfield_range,
          fielding_ratings_outfield_arm: outfield_arm,
          fielding_ratings_outfield_error: outfield_error,
          fielding_ratings_catcher_arm: catcher_arm,
          fielding_ratings_catcher_ability: catcher_ability,
          player_id: player_id
        } = _attrs
      ) do
    %{
      id: player_id,
      infield_range: infield_range,
      infield_arm: infield_arm,
      infield_error: infield_error,
      turn_double_play: turn_double_play,
      outfield_range: outfield_range,
      outfield_arm: outfield_arm,
      outfield_error: outfield_error,
      catcher_arm: catcher_arm,
      catcher_ability: catcher_ability,
      player_id: player_id
    }
  end

  def write_records_to_database(attrs) do
    OOTPUtility.Repo.insert_all(Players.Ratings.Fielding, attrs)

    {[], attrs}
  end

  def validate_changeset(%Ecto.Changeset{changes: %{player_id: player_id}} = _) do
    Imports.Agent.in_cache?(:players, player_id)
  end
end
