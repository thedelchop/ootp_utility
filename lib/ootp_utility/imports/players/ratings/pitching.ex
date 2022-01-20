defmodule OOTPUtility.Imports.Players.Ratings.Pitching do
  alias OOTPUtility.{Imports, Players}

  use Imports,
    from: "players_pitching",
    schema: Players.Ratings.Pitching

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
          pitching_ratings_misc_velocity: velocity,
          pitching_ratings_misc_arm_slot: arm_slot,
          pitching_ratings_misc_stamina: stamina,
          pitching_ratings_misc_ground_fly: groundball_flyball_ratio,
          pitching_ratings_misc_hold: hold,
          player_id: player_id
        } = _attrs
      ) do
    [
      %{
        type: :ability,
        stuff: overall_stuff,
        movement: overall_movement,
        control: overall_control,
        player_id: player_id,
        velocity: velocity,
        arm_slot: arm_slot,
        stamina: stamina,
        groundball_flyball_ratio: groundball_flyball_ratio,
        hold: hold
      },
      %{
        type: :ability_vs_left,
        stuff: vs_lhp_stuff,
        movement: vs_lhp_movement,
        control: vs_lhp_control,
        player_id: player_id,
        velocity: velocity,
        arm_slot: arm_slot,
        stamina: stamina,
        groundball_flyball_ratio: groundball_flyball_ratio,
        hold: hold
      },
      %{
        type: :ability_vs_right,
        stuff: vs_rhp_stuff,
        movement: vs_rhp_movement,
        control: vs_rhp_control,
        player_id: player_id,
        velocity: velocity,
        arm_slot: arm_slot,
        stamina: stamina,
        groundball_flyball_ratio: groundball_flyball_ratio,
        hold: hold
      },
      %{
        type: :talent,
        stuff: talent_stuff,
        movement: talent_movement,
        control: talent_control,
        player_id: player_id,
        velocity: velocity,
        arm_slot: arm_slot,
        stamina: stamina,
        groundball_flyball_ratio: groundball_flyball_ratio,
        hold: hold
      }
    ]
  end

  def write_records_to_database(attrs) do
    OOTPUtility.Repo.insert_all(Players.Ratings.Pitching, attrs)

    {[], attrs}
  end

  def validate_changeset(%Ecto.Changeset{changes: %{player_id: player_id}} = _) do
    Imports.Agent.in_cache?(:players, player_id)
  end
end
