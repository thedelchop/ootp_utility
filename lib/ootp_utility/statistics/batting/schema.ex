defmodule OOTPUtility.Statistics.Batting.Schema do
  alias OOTPUtility.{Leagues, Teams}

  defmacro __using__(opts) do
    composite_key = Keyword.get(opts, :composite_key, nil)
    foreign_key = Keyword.get(opts, :foreign_key, nil)

    quote do
      import OOTPUtility.Statistics.Batting.Schema

      use OOTPUtility.Schema,
        composite_key: unquote(composite_key),
        foreign_key: unquote(foreign_key)
    end
  end

  defmacro batting_schema(source, do: block) do
    quote do
      schema unquote(source) do
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
end
