defmodule OOTPUtility.Statistics.Pitching.Player.Schema do
  alias OOTPUtility.Players

  defmacro __using__(opts) do
    composite_key = Keyword.get(opts, :composite_key, nil)
    foreign_key = Keyword.get(opts, :foreign_key, nil)

    quote do
      import OOTPUtility.Statistics.Pitching.Player.Schema

      use OOTPUtility.Statistics.Pitching.Schema,
        composite_key: unquote(composite_key),
        foreign_key: unquote(foreign_key)
    end
  end

  defmacro player_pitching_schema(source, do: block) do
    quote do
      pitching_schema unquote(source) do
        field :inherited_runners, :integer
        field :inherited_runners_scored, :integer
        field :inherited_runners_scored_percentage, :float
        field :leverage_index, :float
        field :win_probability_added, :float

        belongs_to :player, Players.Player

        unquote(block)
      end
    end
  end
end
