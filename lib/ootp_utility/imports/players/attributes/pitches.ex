defmodule OOTPUtility.Imports.Players.Attributes.Pitches do
  alias OOTPUtility.{Imports, Players}

  use Imports,
    from: "players_pitching",
    schema: Players.Attribute

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
      # Fastball
      %{name: "fastball", type: :ability, value: fastball_ability, player_id: player_id},
      %{name: "fastball", type: :talent, value: fastball_talent, player_id: player_id},

      # Slider
      %{name: "slider", type: :ability, value: slider_ability, player_id: player_id},
      %{name: "slider", type: :talent, value: slider_talent, player_id: player_id},

      # Curveball
      %{name: "curveball", type: :ability, value: curveball_ability, player_id: player_id},
      %{name: "curveball", type: :talent, value: curveball_talent, player_id: player_id},

      # Screwball
      %{name: "screwball", type: :ability, value: screwball_ability, player_id: player_id},
      %{name: "screwball", type: :talent, value: screwball_talent, player_id: player_id},

      # Forkball
      %{name: "forkball", type: :ability, value: forkball_ability, player_id: player_id},
      %{name: "forkball", type: :talent, value: forkball_talent, player_id: player_id},

      # Changeup
      %{name: "changeup", type: :ability, value: changeup_ability, player_id: player_id},
      %{name: "changeup", type: :talent, value: changeup_talent, player_id: player_id},

      # Sinker
      %{name: "sinker", type: :ability, value: sinker_ability, player_id: player_id},
      %{name: "sinker", type: :talent, value: sinker_talent, player_id: player_id},

      # Splitter
      %{name: "splitter", type: :ability, value: splitter_ability, player_id: player_id},
      %{name: "splitter", type: :talent, value: splitter_talent, player_id: player_id},

      # Knuckleball
      %{name: "knuckleball", type: :ability, value: knuckleball_ability, player_id: player_id},
      %{name: "knuckleball", type: :talent, value: knuckleball_talent, player_id: player_id},

      # Cutter
      %{name: "cutter", type: :ability, value: cutter_ability, player_id: player_id},
      %{name: "cutter", type: :talent, value: cutter_talent, player_id: player_id},

      # Circle Change
      %{
        name: "circle_change",
        type: :ability,
        value: circle_change_ability,
        player_id: player_id
      },
      %{name: "circle_change", type: :talent, value: circle_change_talent, player_id: player_id},

      # Knuckle Curve
      %{
        name: "knuckle_curve",
        type: :ability,
        value: knuckle_curve_ability,
        player_id: player_id
      },
      %{name: "knuckle_curve", type: :talent, value: knuckle_curve_talent, player_id: player_id}
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
