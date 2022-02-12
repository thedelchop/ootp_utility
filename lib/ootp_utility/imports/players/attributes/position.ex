defmodule OOTPUtility.Imports.Players.Attributes.Position do
  alias OOTPUtility.{Imports, Players}

  use Imports,
    from: "players_fielding",
    schema: Players.Attribute

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
    [
      %{name: "pitcher", type: :ability, value: pitcher_experience, player_id: player_id},
      %{name: "catcher", type: :ability, value: catcher_experience, player_id: player_id},
      %{name: "first_base", type: :ability, value: first_base_experience, player_id: player_id},
      %{name: "second_base", type: :ability, value: second_base_experience, player_id: player_id},
      %{name: "third_base", type: :ability, value: third_base_experience, player_id: player_id},
      %{name: "shortstop", type: :ability, value: shortstop_experience, player_id: player_id},
      %{name: "left_field", type: :ability, value: left_field_experience, player_id: player_id},
      %{name: "right_field", type: :ability, value: right_field_experience, player_id: player_id},
      %{
        name: "center_field",
        type: :ability,
        value: center_field_experience,
        player_id: player_id
      }
    ]
    |> Enum.reject(fn
      %{value: "0"} -> true
      _ -> false
    end)
  end

  def write_records_to_database(attrs) do
    OOTPUtility.Repo.insert_all(Players.Attribute, attrs)

    {[], attrs}
  end

  def validate_changeset(%Ecto.Changeset{changes: %{player_id: player_id}} = _) do
    Imports.Agent.in_cache?(:players, player_id)
  end
end
