defmodule OOTPUtility.Statistics.Pitching.Team do
  @type t() :: %__MODULE__{}

  alias OOTPUtility.{Imports, Leagues, Repo, Schema, Teams, Utilities}

  import Ecto.Query, only: [from: 2]

  use Schema

  schema "team_pitching_stats" do
    field :ground_ball_percentage, :float
    field :games_finished, :integer
    field :run_support, :integer
    field :strikeouts_per_9, :float
    field :double_plays, :integer
    field :catchers_interference, :integer
    field :ground_balls, :integer
    field :complete_games, :integer
    field :balks, :integer
    field :games_finished_percentage, :float
    field :pitches_thrown, :integer
    field :holds, :integer
    field :complete_game_percentage, :float
    field :level_id, :string
    field :hit_batsmen, :integer
    field :pitches_per_game, :float
    field :walks, :integer
    field :total_bases, :integer
    field :earned_run_average, :float
    field :relief_appearances, :integer
    field :runners_allowed_per_9, :float
    field :caught_stealing, :integer
    field :intentional_walks, :integer
    field :save_percentage, :float
    field :losses, :integer
    field :strikeouts_to_walks_ratio, :float
    field :fly_balls, :integer
    field :winning_percentage, :float
    field :batting_average, :float
    field :blown_saves, :integer
    field :home_runs_allowed, :integer
    field :quality_start_percentage, :float
    field :games, :integer
    field :wild_pitches, :integer
    field :hits_allowed, :integer
    field :home_runs_allowed_per_9, :float
    field :on_base_percentage, :float
    field :singles, :integer
    field :run_support_per_start, :float
    field :outs_pitched, :integer
    field :sacrifice_flys, :integer
    field :saves, :integer
    field :stolen_bases, :integer
    field :strikeouts, :integer
    field :split_id, :string
    field :slugging, :float
    field :batting_average_on_balls_in_play, :float
    field :at_bats, :integer
    field :quality_starts, :integer
    field :runs_allowed, :integer
    field :batters_faced, :integer
    field :hits_allowed_per_9, :float
    field :earned_runs, :integer
    field :sacrifices, :integer
    field :shutouts, :integer
    field :on_base_plus_slugging, :float
    field :doubles, :integer
    field :walks_hits_per_inning_pitched, :float
    field :year, :integer
    field :wins, :integer
    field :save_opportunities, :integer
    field :triples, :integer
    field :blown_save_percentage, :float
    field :walks_allowed_per_9, :float
    field :fielding_independent_pitching, :float

    belongs_to :team, Teams.Team
    belongs_to :league, Leagues.League
  end

  use Imports, from: "team_pitching_stats.csv"

  def update_import_changeset(changeset) do
    changeset
    |> put_id()
  end

  def sanitize_attributes(attrs) do
    attrs
    |> Map.put(:outs_pitched, calculate_outs_pitched(attrs))
    |> rename_keys()
  end

  defp calculate_outs_pitched(%{ip: innings_pitched, ipf: innings_pitched_fraction} = _) do
    String.to_integer(innings_pitched) * 3 + String.to_integer(innings_pitched_fraction)
  end

  defp rename_keys(attrs),
    do:
      Utilities.rename_keys(attrs, [
        {:ab, :at_bats},
        {:ip, :innings_pitched},
        {:bf, :batters_faced},
        {:tb, :total_bases},
        {:ha, :hits_allowed},
        {:k, :strikeouts},
        {:rs, :run_support},
        {:bb, :walks},
        {:r, :runs_allowed},
        {:er, :earned_runs},
        {:gb, :ground_balls},
        {:fb, :fly_balls},
        {:pi, :pitches_thrown},
        {:g, :games},
        {:gs, :games_started},
        {:w, :wins},
        {:l, :losses},
        {:s, :saves},
        {:sa, :singles},
        {:da, :doubles},
        {:sh, :sacrifices},
        {:sf, :sacrifice_flys},
        {:ta, :triples},
        {:hra, :home_runs_allowed},
        {:bk, :balks},
        {:ci, :catchers_interference},
        {:iw, :intentional_walks},
        {:wp, :wild_pitches},
        {:hp, :hit_batsmen},
        {:gf, :games_finished},
        {:dp, :double_plays},
        {:qs, :quality_starts},
        {:svo, :save_opportunities},
        {:bs, :blown_saves},
        {:ra, :relief_appearances},
        {:cg, :complete_games},
        {:sho, :shutouts},
        {:sb, :stolen_bases},
        {:cs, :caught_stealing},
        {:hld, :holds},
        {:r9, :runners_allowed_per_9},
        {:avg, :batting_average},
        {:obp, :on_base_percentage},
        {:slg, :slugging},
        {:ops, :on_base_plus_slugging},
        {:h9, :hits_allowed_per_9},
        {:k9, :strikeouts_per_9},
        {:hr9, :home_runs_allowed_per_9},
        {:bb9, :walks_allowed_per_9},
        {:cgp, :complete_game_percentage},
        {:fip, :fielding_independent_pitching},
        {:qsp, :quality_start_percentage},
        {:winp, :winning_percentage},
        {:rsg, :run_support_per_start},
        {:svp, :save_percentage},
        {:bsvp, :blown_save_percentage},
        {:gfp, :games_finished_percentage},
        {:era, :earned_run_average},
        {:pig, :pitches_per_game},
        {:whip, :walks_hits_per_inning_pitched},
        {:gbfbp, :ground_ball_percentage},
        {:kbb, :strikeouts_to_walks_ratio},
        {:babip, :batting_average_on_balls_in_play}
      ])

  def valid_for_import?(%{league_id: "0"} = _attrs), do: false

  def valid_for_import?(%{team_id: team_id} = _attrs) do
    Repo.exists?(from t in Teams.Team, where: t.id == ^team_id)
  end

  defp put_id(%Ecto.Changeset{changes: %{team_id: team_id}} = changeset),
    do: change(changeset, %{id: team_id})
end
