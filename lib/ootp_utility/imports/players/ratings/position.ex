defmodule OOTPUtility.Imports.Players.Ratings.Position do
  alias OOTPUtility.{Imports, Players}

  use Imports,
    from: "players_fielding",
    schema: Players.Ratings.Position

  def sanitize_attributes(
        %{
          fielding_rating_pos1: pitcher_experience,
          fielding_rating_pos2: catcher_experience,
          fielding_rating_pos3: first_base_experience,
          fielding_rating_pos4: second_base_experience,
          fielding_rating_pos5: third_base_experience,
          fielding_rating_pos6: shortstop_experience,
          fielding_rating_pos7: left_field_experience,
          fielding_rating_pos8: center_field_experience,
          fielding_rating_pos9: right_field_experience,
          player_id: player_id
        } = _attrs
      ) do
    %{
      pitcher: pitcher_experience,
      catcher: catcher_experience,
      first_base: first_base_experience,
      second_base: second_base_experience,
      third_base: third_base_experience,
      shortstop: shortstop_experience,
      left_field: left_field_experience,
      center_field: center_field_experience,
      right_field: right_field_experience,
      player_id: player_id
    }
  end

  def write_records_to_database(attrs) do
    OOTPUtility.Repo.insert_all(Players.Ratings.Position, attrs)

    {[], attrs}
  end

  def validate_changeset(%Ecto.Changeset{changes: %{player_id: player_id}} = _) do
    Imports.Agent.in_cache?(:players, player_id)
  end
end
