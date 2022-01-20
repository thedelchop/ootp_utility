defmodule OOTPUtility.Imports.Players.Ratings.Pitches do
  alias OOTPUtility.{Imports, Players}

  use Imports,
    from: "players_pitching",
    schema: Players.Ratings.Pitches

  def sanitize_attributes(
        %{
          pitching_ratings_pitches_fastball: fastball_ability,
          pitching_ratings_pitches_slider: slider_ability,
          pitching_ratings_pitches_curveball: curveball_ability,
          pitching_ratings_pitches_screwball: screwball_ability,
          pitching_ratings_pitches_forkball: forkball_ability,
          pitching_ratings_pitches_changeup: changeup_ability,
          pitching_ratings_pitches_sinker: sinker_ability,
          pitching_ratings_pitches_splitter: splitter_ability,
          pitching_ratings_pitches_knuckleball: knuckleball_ability,
          pitching_ratings_pitches_cutter: cutter_ability,
          pitching_ratings_pitches_circlechange: circle_change_ability,
          pitching_ratings_pitches_knucklecurve: knuckle_curve_ability,
          pitching_ratings_pitches_talent_fastball: fastball_talent,
          pitching_ratings_pitches_talent_slider: slider_talent,
          pitching_ratings_pitches_talent_curveball: curveball_talent,
          pitching_ratings_pitches_talent_screwball: screwball_talent,
          pitching_ratings_pitches_talent_forkball: forkball_talent,
          pitching_ratings_pitches_talent_changeup: changeup_talent,
          pitching_ratings_pitches_talent_sinker: sinker_talent,
          pitching_ratings_pitches_talent_splitter: splitter_talent,
          pitching_ratings_pitches_talent_knuckleball: knuckleball_talent,
          pitching_ratings_pitches_talent_cutter: cutter_talent,
          pitching_ratings_pitches_talent_circlechange: circle_change_talent,
          pitching_ratings_pitches_talent_knucklecurve: knuckle_curve_talent,
          player_id: player_id
        } = _attrs
      ) do
    [
      %{
        type: :ability,
        fastball: fastball_ability,
        slider: slider_ability,
        curveball: curveball_ability,
        screwball: screwball_ability,
        forkball: forkball_ability,
        changeup: changeup_ability,
        sinker: sinker_ability,
        splitter: splitter_ability,
        knuckleball: knuckleball_ability,
        cutter: cutter_ability,
        circle_change: circle_change_ability,
        knuckle_curve: knuckle_curve_ability,
        player_id: player_id
      },
      %{
        type: :talent,
        fastball: fastball_talent,
        slider: slider_talent,
        curveball: curveball_talent,
        screwball: screwball_talent,
        forkball: forkball_talent,
        changeup: changeup_talent,
        sinker: sinker_talent,
        splitter: splitter_talent,
        knuckleball: knuckleball_talent,
        cutter: cutter_talent,
        circle_change: circle_change_talent,
        knuckle_curve: knuckle_curve_talent,
        player_id: player_id
      }
    ]
  end

  def write_records_to_database(attrs) do
    OOTPUtility.Repo.insert_all(Players.Ratings.Pitches, attrs)

    {[], attrs}
  end

  def validate_changeset(%Ecto.Changeset{changes: %{player_id: player_id}} = _) do
    Imports.Agent.in_cache?(:players, player_id)
  end
end
