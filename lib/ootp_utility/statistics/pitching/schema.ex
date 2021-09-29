defmodule OOTPUtility.Statistics.Pitching.Schema do
  alias OOTPUtility.{Imports, Leagues, Teams, Utilities}

  defmacro __using__(opts) do
    filename = Keyword.fetch!(opts, :from)
    composite_key = Keyword.get(opts, :composite_key, nil)
    foreign_key = Keyword.get(opts, :foreign_key, nil)

    quote do
      import OOTPUtility.Statistics.Pitching.Schema

      use Imports.Schema,
        from: unquote(filename),
        composite_key: unquote(composite_key),
        foreign_key: unquote(foreign_key)

      def update_pitching_import_changeset(changeset),
        do:
          OOTPUtility.Statistics.Pitching.Schema.update_pitching_import_changeset(
            __MODULE__,
            changeset
          )

      def update_import_changeset(changeset) do
        changeset
        |> update_pitching_import_changeset()
        |> put_composite_key()
      end

      def sanitize_pitching_attributes(attrs),
        do: OOTPUtility.Statistics.Pitching.Schema.sanitize_pitching_attributes(__MODULE__, attrs)

      def sanitize_attributes(attrs) do
        attrs
        |> OOTPUtility.Statistics.Pitching.Schema.rename_keys()
        |> sanitize_pitching_attributes()
      end

      defoverridable sanitize_pitching_attributes: 1, update_pitching_import_changeset: 1
    end
  end

  defmacro pitching_schema(source, do: block) do
    quote do
      import_schema unquote(source) do
        field :at_bats, :integer
        field :balks, :integer
        field :plate_appearances, :integer
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
        field :fly_balls, :integer
        field :games, :integer
        field :games_finished, :integer
        field :games_started, :integer
        field :games_finished_percentage, :float
        field :ground_ball_percentage, :float
        field :ground_balls, :integer
        field :hit_by_pitch, :integer
        field :hits, :integer
        field :hits_per_9, :float
        field :holds, :integer
        field :home_runs, :integer
        field :home_runs_per_9, :float
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
        field :runs_per_9, :float
        field :runs, :integer
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
        field :walks_per_9, :float
        field :walks_hits_per_inning_pitched, :float
        field :wild_pitches, :integer
        field :winning_percentage, :float
        field :wins, :integer
        field :year, :integer

        belongs_to :team, Teams.Team
        belongs_to :league, Leagues.League

        unquote(block)
      end
    end
  end

  def rename_keys(attrs),
    do:
      Utilities.rename_keys(attrs, [
        {:ab, :at_bats},
        {:bb, :walks},
        {:bf, :plate_appearances},
        {:bk, :balks},
        {:bs, :blown_saves},
        {:cg, :complete_games},
        {:ci, :catchers_interference},
        {:cs, :caught_stealing},
        {:da, :doubles},
        {:dp, :double_plays},
        {:er, :earned_runs},
        {:fb, :fly_balls},
        {:g, :games},
        {:gb, :ground_balls},
        {:gf, :games_finished},
        {:gs, :games_started},
        {:ha, :hits},
        {:hld, :holds},
        {:hp, :hit_by_pitch},
        {:hra, :home_runs},
        {:iw, :intentional_walks},
        {:k, :strikeouts},
        {:l, :losses},
        {:pi, :pitches_thrown},
        {:qs, :quality_starts},
        {:r, :runs},
        {:ra, :relief_appearances},
        {:rs, :run_support},
        {:s, :saves},
        {:sa, :singles},
        {:sb, :stolen_bases},
        {:sf, :sacrifice_flys},
        {:sh, :sacrifices},
        {:sho, :shutouts},
        {:svo, :save_opportunities},
        {:ta, :triples},
        {:tb, :total_bases},
        {:w, :wins},
        {:wp, :wild_pitches}
      ])

  def update_pitching_import_changeset(_module, changeset), do: changeset

  def update_import_changeset(module, changeset) do
    OOTPUtility.Imports.update_import_changeset(module, changeset)
  end

  def sanitize_pitching_attributes(_module, attrs), do: attrs
end
