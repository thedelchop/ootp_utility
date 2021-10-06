defmodule OOTPUtility.Imports.Statistics.Fielding do
  defmacro __using__(opts) do
    header_renames = Keyword.get(opts, :headers, [])
    filename = Keyword.get(opts, :from)
    schema = Keyword.get(opts, :schema)

    shared_renames = [
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

  def calculate_outs_played(%{ip: innings_played, ipf: innings_played_fraction} = _) do
    String.to_integer(innings_played) * 3 + String.to_integer(innings_played_fraction)
  end
end
