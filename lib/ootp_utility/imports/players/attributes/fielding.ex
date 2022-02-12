defmodule OOTPUtility.Imports.Players.Attributes.Fielding do
  alias OOTPUtility.{Imports, Players}

  use Imports,
    from: "players_fielding",
    schema: Players.Attribute

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
    [
      %{
        name: "infield_range",
        type: :ability,
        value: infield_range,
        player_id: player_id
      },
      %{
        name: "infield_arm",
        type: :ability,
        value: infield_arm,
        player_id: player_id
      },
      %{
        name: "infield_error",
        type: :ability,
        value: infield_error,
        player_id: player_id
      },
      %{
        name: "turn_double_play",
        type: :ability,
        value: turn_double_play,
        player_id: player_id
      },
      %{
        name: "outfield_range",
        type: :ability,
        value: outfield_range,
        player_id: player_id
      },
      %{
        name: "outfield_arm",
        type: :ability,
        value: outfield_arm,
        player_id: player_id
      },
      %{
        name: "outfield_error",
        type: :ability,
        value: outfield_error,
        player_id: player_id
      },
      %{
        name: "catcher_arm",
        type: :ability,
        value: catcher_arm,
        player_id: player_id
      },
      %{
        name: "catcher_ability",
        type: :ability,
        value: catcher_ability,
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
