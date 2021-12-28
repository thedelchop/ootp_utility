defmodule OOTPUtility.Statistics.Fielding.Schema do
  alias OOTPUtility.{Leagues, Teams}

  defmacro __using__(opts) do
    composite_key = Keyword.get(opts, :composite_key, nil)
    foreign_key = Keyword.get(opts, :foreign_key, nil)

    quote do
      import OOTPUtility.Statistics.Fielding.Schema

      use OOTPUtility.Schema,
        composite_key: unquote(composite_key),
        foreign_key: unquote(foreign_key)
    end
  end

  defmacro fielding_schema(source, do: block) do
    quote do
      schema unquote(source) do
        field :level, Ecto.Enum,
          values: [
            major: 1,
            triple_a: 2,
            double_a: 3,
            single_a: 4,
            low_a: 5,
            rookie: 6,
            international: 8,
            college: 10,
            high_school: 11
          ]

        field :assists, :integer
        field :double_plays, :integer
        field :errors, :integer
        field :fielding_percentage, :float
        field :games, :integer
        field :games_started, :integer
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
end
