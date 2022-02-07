defmodule OOTPUtility.Imports.Players.Ratings.Batting do
  alias OOTPUtility.{Imports, Players}

  use Imports,
    from: "players_batting",
    schema: Players.Ratings.Batting

  def sanitize_attributes(
        %{
          batting_ratings_overall_contact: overall_contact,
          batting_ratings_overall_gap: overall_gap,
          batting_ratings_overall_eye: overall_eye,
          batting_ratings_overall_strikeouts: overall_strikeouts,
          batting_ratings_overall_power: overall_power,
          batting_ratings_vsr_contact: vs_rhp_contact,
          batting_ratings_vsr_gap: vs_rhp_gap,
          batting_ratings_vsr_eye: vs_rhp_eye,
          batting_ratings_vsr_strikeouts: vs_rhp_strikeouts,
          batting_ratings_vsr_power: vs_rhp_power,
          batting_ratings_vsl_contact: vs_lhp_contact,
          batting_ratings_vsl_gap: vs_lhp_gap,
          batting_ratings_vsl_eye: vs_lhp_eye,
          batting_ratings_vsl_strikeouts: vs_lhp_strikeouts,
          batting_ratings_vsl_power: vs_lhp_power,
          batting_ratings_talent_contact: talent_contact,
          batting_ratings_talent_gap: talent_gap,
          batting_ratings_talent_eye: talent_eye,
          batting_ratings_talent_strikeouts: talent_strikeouts,
          batting_ratings_talent_power: talent_power,
          batting_ratings_misc_bunt: bunt,
          batting_ratings_misc_bunt_for_hit: bunt_for_hit,
          batting_ratings_misc_gb_hitter_type: gb_hitter_type,
          batting_ratings_misc_fb_hitter_type: fb_hitter_type,
          player_id: player_id
        } = _attrs
      ) do
    [
      %{
        id: "#{player_id}-1",
        type: :ability,
        contact: overall_contact,
        gap_power: overall_gap,
        eye: overall_eye,
        avoid_strikeouts: overall_strikeouts,
        home_run_power: overall_power,
        bunt: bunt,
        bunt_for_hit: bunt_for_hit,
        groundball_hitter_type: gb_hitter_type,
        flyball_hitter_type: fb_hitter_type,
        player_id: player_id
      },
      %{
        id: "#{player_id}-2",
        type: :ability_vs_left,
        contact: vs_lhp_contact,
        gap_power: vs_lhp_gap,
        eye: vs_lhp_eye,
        avoid_strikeouts: vs_lhp_strikeouts,
        home_run_power: vs_lhp_power,
        bunt: bunt,
        bunt_for_hit: bunt_for_hit,
        groundball_hitter_type: gb_hitter_type,
        flyball_hitter_type: fb_hitter_type,
        player_id: player_id
      },
      %{
        id: "#{player_id}-3",
        type: :ability_vs_right,
        contact: vs_rhp_contact,
        gap_power: vs_rhp_gap,
        eye: vs_rhp_eye,
        avoid_strikeouts: vs_rhp_strikeouts,
        home_run_power: vs_rhp_power,
        bunt: bunt,
        bunt_for_hit: bunt_for_hit,
        groundball_hitter_type: gb_hitter_type,
        flyball_hitter_type: fb_hitter_type,
        player_id: player_id
      },
      %{
        id: "#{player_id}-4",
        type: :talent,
        contact: talent_contact,
        gap_power: talent_gap,
        eye: talent_eye,
        avoid_strikeouts: talent_strikeouts,
        home_run_power: talent_power,
        bunt: bunt,
        bunt_for_hit: bunt_for_hit,
        groundball_hitter_type: gb_hitter_type,
        flyball_hitter_type: fb_hitter_type,
        player_id: player_id
      }
    ]
  end

  def write_records_to_database(attrs) do
    OOTPUtility.Repo.insert_all(Players.Ratings.Batting, attrs)

    {[], attrs}
  end

  def validate_changeset(%Ecto.Changeset{changes: %{player_id: player_id}} = _) do
    Imports.Agent.in_cache?(:players, player_id)
  end
end
