defmodule OOTPUtility.Imports.Players.Attributes.Pitching do
  alias OOTPUtility.{Imports, Players}

  use Imports,
    from: "players_pitching",
    schema: Players.Attribute

  def sanitize_attributes(
        %{
          pitching_ratings_overall_stuff: overall_stuff,
          pitching_ratings_overall_movement: overall_movement,
          pitching_ratings_overall_control: overall_control,
          pitching_ratings_vsr_stuff: vs_rhp_stuff,
          pitching_ratings_vsr_movement: vs_rhp_movement,
          pitching_ratings_vsr_control: vs_rhp_control,
          pitching_ratings_vsl_stuff: vs_lhp_stuff,
          pitching_ratings_vsl_movement: vs_lhp_movement,
          pitching_ratings_vsl_control: vs_lhp_control,
          pitching_ratings_talent_stuff: talent_stuff,
          pitching_ratings_talent_movement: talent_movement,
          pitching_ratings_talent_control: talent_control,
          player_id: player_id
        } = _attrs
      ) do
    [
      %{name: "stuff", type: :ability, value: overall_stuff, player_id: player_id},
      %{name: "stuff", type: :ability_vs_right, value: vs_rhp_stuff, player_id: player_id},
      %{name: "stuff", type: :ability_vs_left, value: vs_lhp_stuff, player_id: player_id},
      %{name: "stuff", type: :talent, value: talent_stuff, player_id: player_id},
      %{name: "movement", type: :ability, value: overall_movement, player_id: player_id},
      %{name: "movement", type: :ability_vs_right, value: vs_rhp_movement, player_id: player_id},
      %{name: "movement", type: :ability_vs_left, value: vs_lhp_movement, player_id: player_id},
      %{name: "movement", type: :talent, value: talent_movement, player_id: player_id},
      %{name: "control", type: :ability, value: overall_control, player_id: player_id},
      %{name: "control", type: :ability_vs_right, value: vs_rhp_control, player_id: player_id},
      %{name: "control", type: :ability_vs_left, value: vs_lhp_control, player_id: player_id},
      %{name: "control", type: :talent, value: talent_control, player_id: player_id}
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
    Imports.ImportAgent.in_cache?(:players, player_id)
  end
end
