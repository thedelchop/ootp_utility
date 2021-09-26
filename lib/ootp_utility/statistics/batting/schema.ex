defmodule OOTPUtility.Statistics.Batting.Schema do
  alias OOTPUtility.{Imports, Leagues, Teams, Utilities}

  defmacro __using__(opts) do
    filename = Keyword.fetch!(opts, :from)
    composite_key = Keyword.get(opts, :composite_key, nil)
    foreign_key = Keyword.get(opts, :foreign_key, nil)

    quote do
      import OOTPUtility.Statistics.Batting.Schema

      use Imports.Schema,
        from: unquote(filename),
        composite_key: unquote(composite_key),
        foreign_key: unquote(foreign_key)

      def update_batting_import_changeset(changeset),
        do:
          OOTPUtility.Statistics.Batting.Schema.update_batting_import_changeset(
            __MODULE__,
            changeset
          )

      def update_import_changeset(changeset) do
        changeset
        |> update_batting_import_changeset()
        |> put_composite_key()
      end

      def sanitize_batting_attributes(attrs),
        do: OOTPUtility.Statistics.Batting.Schema.sanitize_batting_attributes(__MODULE__, attrs)

      def sanitize_attributes(attrs) do
        attrs
        |> OOTPUtility.Statistics.Batting.Schema.rename_keys()
        |> sanitize_batting_attributes()
      end

      defoverridable sanitize_batting_attributes: 1, update_batting_import_changeset: 1
    end
  end

  defmacro batting_schema(source, do: block) do
    quote do
      import_schema unquote(source) do
        field :level_id, :integer
        field :year, :integer

        field :games, :integer
        field :games_started, :integer

        field :at_bats, :integer
        field :plate_appearances, :integer

        field :hits, :integer
        field :singles, :integer
        field :doubles, :integer
        field :triples, :integer
        field :home_runs, :integer
        field :extra_base_hits, :integer
        field :total_bases, :integer

        field :strikeouts, :integer
        field :walks, :integer
        field :intentional_walks, :integer
        field :hit_by_pitch, :integer
        field :catchers_interference, :integer

        field :runs, :integer
        field :runs_batted_in, :integer

        field :double_plays, :integer
        field :sacrifice_flys, :integer
        field :sacrifices, :integer

        field :stolen_bases, :integer
        field :caught_stealing, :integer

        field :batting_average, :float
        field :isolated_power, :float
        field :on_base_percentage, :float
        field :on_base_plus_slugging, :float
        field :slugging, :float
        field :stolen_base_percentage, :float
        field :runs_created, :float

        belongs_to :league, Leagues.League
        belongs_to :team, Teams.Team

        unquote(block)
      end
    end
  end

  def rename_keys(attrs) do
    Utilities.rename_keys(attrs, [
      {:ab, :at_bats},
      {:bb, :walks},
      {:ci, :catchers_interference},
      {:cs, :caught_stealing},
      {:d, :doubles},
      {:g, :games},
      {:gdp, :double_plays},
      {:gs, :games_started},
      {:h, :hits},
      {:hp, :hit_by_pitch},
      {:hr, :home_runs},
      {:ibb, :intentional_walks},
      {:k, :strikeouts},
      {:pa, :plate_appearances},
      {:r, :runs},
      {:rbi, :runs_batted_in},
      {:sb, :stolen_bases},
      {:sf, :sacrifice_flys},
      {:sh, :sacrifices},
      {:t, :triples}
    ])
  end

  def update_batting_import_changeset(_module, changeset), do: changeset

  def update_import_changeset(module, changeset) do
    OOTPUtility.Imports.update_import_changeset(module, changeset)
  end

  def sanitize_batting_attributes(_module, attrs), do: attrs

  def sanitize_attributes(module, attrs) do
    OOTPUtility.Imports.sanitize_attributes(module, attrs)
  end
end
