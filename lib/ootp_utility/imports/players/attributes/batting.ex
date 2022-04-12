defmodule OOTPUtility.Imports.Players.Attributes.Batting do
  alias OOTPUtility.{Imports, Players}

  use Imports,
    from: "players_batting",
    schema: Players.Attribute

  def sanitize_attributes(
        %{
          batting_ratings_overall_contact: overall_contact,
          batting_ratings_overall_gap: overall_gap_power,
          batting_ratings_overall_eye: overall_eye,
          batting_ratings_overall_strikeouts: overall_strikeouts,
          batting_ratings_overall_power: overall_home_run_power,
          batting_ratings_vsr_contact: vs_rhp_contact,
          batting_ratings_vsr_gap: vs_rhp_gap_power,
          batting_ratings_vsr_eye: vs_rhp_eye,
          batting_ratings_vsr_strikeouts: vs_rhp_strikeouts,
          batting_ratings_vsr_power: vs_rhp_home_run_power,
          batting_ratings_vsl_contact: vs_lhp_contact,
          batting_ratings_vsl_gap: vs_lhp_gap_power,
          batting_ratings_vsl_eye: vs_lhp_eye,
          batting_ratings_vsl_strikeouts: vs_lhp_strikeouts,
          batting_ratings_vsl_power: vs_lhp_home_run_power,
          batting_ratings_talent_contact: talent_contact,
          batting_ratings_talent_gap: talent_gap_power,
          batting_ratings_talent_eye: talent_eye,
          batting_ratings_talent_strikeouts: talent_strikeouts,
          batting_ratings_talent_power: talent_home_run_power,
          batting_ratings_misc_bunt: bunt,
          batting_ratings_misc_bunt_for_hit: bunt_for_hit,
          player_id: player_id
        } = _attrs
      ) do
    [
      %{name: "contact", type: :ability, value: overall_contact, player_id: player_id},
      %{name: "contact", type: :ability_vs_right, value: vs_rhp_contact, player_id: player_id},
      %{name: "contact", type: :ability_vs_left, value: vs_lhp_contact, player_id: player_id},
      %{name: "contact", type: :talent, value: talent_contact, player_id: player_id},
      %{name: "gap_power", type: :ability, value: overall_gap_power, player_id: player_id},
      %{
        name: "gap_power",
        type: :ability_vs_right,
        value: vs_rhp_gap_power,
        player_id: player_id
      },
      %{name: "gap_power", type: :ability_vs_left, value: vs_lhp_gap_power, player_id: player_id},
      %{name: "gap_power", type: :talent, value: talent_gap_power, player_id: player_id},
      %{
        name: "home_run_power",
        type: :ability,
        value: overall_home_run_power,
        player_id: player_id
      },
      %{
        name: "home_run_power",
        type: :ability_vs_right,
        value: vs_rhp_home_run_power,
        player_id: player_id
      },
      %{
        name: "home_run_power",
        type: :ability_vs_left,
        value: vs_lhp_home_run_power,
        player_id: player_id
      },
      %{
        name: "home_run_power",
        type: :talent,
        value: talent_home_run_power,
        player_id: player_id
      },
      %{name: "eye", type: :ability, value: overall_eye, player_id: player_id},
      %{name: "eye", type: :ability_vs_right, value: vs_rhp_eye, player_id: player_id},
      %{name: "eye", type: :ability_vs_left, value: vs_lhp_eye, player_id: player_id},
      %{name: "eye", type: :talent, value: talent_eye, player_id: player_id},
      %{
        name: "avoid_strikeouts",
        type: :ability,
        value: overall_strikeouts,
        player_id: player_id
      },
      %{
        name: "avoid_strikeouts",
        type: :ability_vs_right,
        value: vs_rhp_strikeouts,
        player_id: player_id
      },
      %{
        name: "avoid_strikeouts",
        type: :ability_vs_left,
        value: vs_lhp_strikeouts,
        player_id: player_id
      },
      %{name: "avoid_strikeouts", type: :talent, value: talent_strikeouts, player_id: player_id},
      %{name: "sacrifice_bunt", type: :ability, value: bunt, player_id: player_id},
      %{name: "bunt_for_hit", type: :ability, value: bunt_for_hit, player_id: player_id}
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
