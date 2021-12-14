defmodule OOTPUtility.Imports.Statistics.Batting do
  import OOTPUtility.Imports.Statistics, only: [add_statistic: 2]

  defmacro __using__(opts) do
    header_renames = Keyword.get(opts, :headers, [])
    filename = Keyword.get(opts, :from)
    schema = Keyword.get(opts, :schema)

    shared_renames = [
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
    ]

    headers =
      shared_renames
      |> Keyword.merge(header_renames)

    quote do
      use OOTPUtility.Imports,
        from: unquote(filename),
        headers: unquote(headers),
        schema: unquote(schema)
    end
  end

  def add_missing_statistics(%Ecto.Changeset{} = changeset) do
    changeset
    |> add_statistic(:singles)
    |> add_statistic(:extra_base_hits)
    |> add_statistic(:total_bases)
    |> add_statistic(:batting_average)
    |> add_statistic(:on_base_percentage)
    |> add_statistic(:slugging)
    |> add_statistic(:runs_created)
    |> add_statistic(:on_base_plus_slugging)
    |> add_statistic(:isolated_power)
    |> add_statistic(:stolen_base_percentage)
    |> add_statistic(:batting_average_on_balls_in_play)
  end
end
