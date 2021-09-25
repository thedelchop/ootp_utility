defmodule OOTPUtility.Statistics.Pitching.Team.Schema do
  alias OOTPUtility.{Imports, Leagues, Repo, Teams, Utilities}

  defmacro __using__([{:from, filename}, {:to, source}]) do
    quote do
      use Imports.Schema,
        from: unquote(filename),
        composite_key: [:team_id, :year],
        foreign_key: [:id, :year]

      import Ecto.Query, only: [from: 2]

      import_schema unquote(source) do
        field :at_bats, :integer
        field :balks, :integer
        field :batters_faced, :integer
        field :batting_average, :float
        field :batting_average_on_balls_in_play, :float
        field :blown_save_percentage, :float
        field :blown_saves, :integer
        field :catchers_interference, :integer
        field :caught_stealing, :integer
        field :complete_game_percentage, :float
        field :complete_games, :integer
        field :double_plays, :integer
        field :doubles, :integer
        field :earned_run_average, :float
        field :earned_runs, :integer
        field :fielding_independent_pitching, :float
        field :fly_balls, :integer
        field :games, :integer
        field :games_finished, :integer
        field :games_finished_percentage, :float
        field :ground_ball_percentage, :float
        field :ground_balls, :integer
        field :hit_batsmen, :integer
        field :hits_allowed, :integer
        field :hits_allowed_per_9, :float
        field :holds, :integer
        field :home_runs_allowed, :integer
        field :home_runs_allowed_per_9, :float
        field :intentional_walks, :integer
        field :level_id, :string
        field :losses, :integer
        field :on_base_percentage, :float
        field :on_base_plus_slugging, :float
        field :outs_pitched, :integer
        field :pitches_per_game, :float
        field :pitches_thrown, :integer
        field :quality_start_percentage, :float
        field :quality_starts, :integer
        field :relief_appearances, :integer
        field :run_support, :integer
        field :run_support_per_start, :float
        field :runners_allowed_per_9, :float
        field :runs_allowed, :integer
        field :sacrifice_flys, :integer
        field :sacrifices, :integer
        field :save_opportunities, :integer
        field :save_percentage, :float
        field :saves, :integer
        field :shutouts, :integer
        field :singles, :integer
        field :slugging, :float
        field :stolen_bases, :integer
        field :strikeouts, :integer
        field :strikeouts_per_9, :float
        field :strikeouts_to_walks_ratio, :float
        field :total_bases, :integer
        field :triples, :integer
        field :walks, :integer
        field :walks_allowed_per_9, :float
        field :walks_hits_per_inning_pitched, :float
        field :wild_pitches, :integer
        field :winning_percentage, :float
        field :wins, :integer
        field :year, :integer

        belongs_to :team, Teams.Team
        belongs_to :league, Leagues.League
      end

      def update_import_changeset(changeset) do
        changeset
        |> put_composite_key()
      end

      def sanitize_attributes(attrs) do
        attrs
        |> Map.put(:outs_pitched, calculate_outs_pitched(attrs))
        |> rename_keys()
      end

      def valid_for_import?(%{league_id: "0"} = _attrs), do: false

      def valid_for_import?(%{team_id: team_id} = _attrs) do
        Repo.exists?(from t in Teams.Team, where: t.id == ^team_id)
      end

      defp rename_keys(attrs),
        do:
          Utilities.rename_keys(attrs, [
            {:ab, :at_bats},
            {:avg, :batting_average},
            {:babip, :batting_average_on_balls_in_play},
            {:bb, :walks},
            {:bb9, :walks_allowed_per_9},
            {:bf, :batters_faced},
            {:bk, :balks},
            {:bs, :blown_saves},
            {:bsvp, :blown_save_percentage},
            {:cg, :complete_games},
            {:cgp, :complete_game_percentage},
            {:ci, :catchers_interference},
            {:cs, :caught_stealing},
            {:da, :doubles},
            {:dp, :double_plays},
            {:er, :earned_runs},
            {:era, :earned_run_average},
            {:fb, :fly_balls},
            {:fip, :fielding_independent_pitching},
            {:g, :games},
            {:gb, :ground_balls},
            {:gbfbp, :ground_ball_percentage},
            {:gf, :games_finished},
            {:gfp, :games_finished_percentage},
            {:gs, :games_started},
            {:h9, :hits_allowed_per_9},
            {:ha, :hits_allowed},
            {:hld, :holds},
            {:hp, :hit_batsmen},
            {:hr9, :home_runs_allowed_per_9},
            {:hra, :home_runs_allowed},
            {:ip, :innings_pitched},
            {:iw, :intentional_walks},
            {:k, :strikeouts},
            {:k9, :strikeouts_per_9},
            {:kbb, :strikeouts_to_walks_ratio},
            {:l, :losses},
            {:obp, :on_base_percentage},
            {:ops, :on_base_plus_slugging},
            {:pi, :pitches_thrown},
            {:pig, :pitches_per_game},
            {:qs, :quality_starts},
            {:qsp, :quality_start_percentage},
            {:r, :runs_allowed},
            {:r9, :runners_allowed_per_9},
            {:ra, :relief_appearances},
            {:rs, :run_support},
            {:rsg, :run_support_per_start},
            {:s, :saves},
            {:sa, :singles},
            {:sb, :stolen_bases},
            {:sf, :sacrifice_flys},
            {:sh, :sacrifices},
            {:sho, :shutouts},
            {:slg, :slugging},
            {:svo, :save_opportunities},
            {:svp, :save_percentage},
            {:ta, :triples},
            {:tb, :total_bases},
            {:w, :wins},
            {:whip, :walks_hits_per_inning_pitched},
            {:winp, :winning_percentage},
            {:wp, :wild_pitches}
          ])

      defp calculate_outs_pitched(%{ip: innings_pitched, ipf: innings_pitched_fraction} = _) do
        String.to_integer(innings_pitched) * 3 + String.to_integer(innings_pitched_fraction)
      end
    end
  end
end
