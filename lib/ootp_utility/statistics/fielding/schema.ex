defmodule OOTPUtility.Statistics.Fielding.Schema do
  alias OOTPUtility.{Imports, Leagues, Teams, Utilities}

  defmacro __using__(opts) do
    filename = Keyword.fetch!(opts, :from)
    composite_key = Keyword.get(opts, :composite_key, nil)
    foreign_key = Keyword.get(opts, :foreign_key, nil)

    quote do
      import OOTPUtility.Statistics.Fielding.Schema

      use Imports.Schema,
        from: unquote(filename),
        composite_key: unquote(composite_key),
        foreign_key: unquote(foreign_key)

      def update_fielding_import_changeset(changeset),
        do:
          OOTPUtility.Statistics.Fielding.Schema.update_fielding_import_changeset(
            __MODULE__,
            changeset
          )

      def update_import_changeset(changeset) do
        changeset
        |> put_composite_key()
        |> update_fielding_import_changeset()
      end

      def sanitize_fielding_attributes(attrs),
        do: OOTPUtility.Statistics.Fielding.Schema.sanitize_fielding_attributes(__MODULE__, attrs)

      def sanitize_attributes(attrs) do
        attrs
        |> Map.put(:outs_played, calculate_outs_played(attrs))
        |> OOTPUtility.Statistics.Fielding.Schema.rename_keys()
        |> sanitize_fielding_attributes()
      end

      defp calculate_outs_played(%{ip: innings_played, ipf: innings_played_fraction} = _) do
        String.to_integer(innings_played) * 3 + String.to_integer(innings_played_fraction)
      end

      defoverridable sanitize_fielding_attributes: 1, update_fielding_import_changeset: 1
    end
  end

  defmacro fielding_schema(source, do: block) do
    quote do
      import_schema unquote(source) do
        field :assists, :integer
        field :double_plays, :integer
        field :errors, :integer
        field :fielding_percentage, :float
        field :games, :integer
        field :games_started, :integer
        field :level_id, :integer
        field :outs_played, :integer
        field :past_balls, :integer
        field :put_outs, :integer
        field :range_factor, :float
        field :runners_thrown_out, :integer
        field :runners_thrown_out_percentage, :float
        field :stolen_base_attempts, :integer
        field :total_chances, :integer
        field :triple_plays, :integer
        field :year, :integer

        belongs_to :team, Teams.Team
        belongs_to :league, Leagues.League

        unquote(block)
      end
    end
  end

  def rename_keys(attrs) do
    Utilities.rename_keys(attrs, [
      {:g, :games},
      {:gs, :games_started},
      {:tc, :total_chances},
      {:a, :assists},
      {:po, :put_outs},
      {:e, :errors},
      {:dp, :double_plays},
      {:tp, :triple_plays},
      {:pb, :past_balls},
      {:sba, :stolen_base_attempts},
      {:rto, :runners_thrown_out},
      {:pct, :fielding_percentage},
      {:range, :range_factor},
      {:rtop, :runners_thrown_out_percentage},
      {:cera, :catcher_earned_run_average}
    ])
  end

  def update_fielding_import_changeset(_module, changeset), do: changeset

  def update_import_changeset(module, changeset) do
    OOTPUtility.Imports.update_import_changeset(module, changeset)
  end

  def sanitize_fielding_attributes(_module, attrs), do: attrs

  def sanitize_attributes(module, attrs) do
    OOTPUtility.Imports.sanitize_attributes(module, attrs)
  end
end
