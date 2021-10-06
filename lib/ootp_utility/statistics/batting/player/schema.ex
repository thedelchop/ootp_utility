defmodule OOTPUtility.Statistics.Batting.Player.Schema do
  alias OOTPUtility.Players

  defmacro __using__(opts) do
    composite_key = Keyword.get(opts, :composite_key, nil)
    foreign_key = Keyword.get(opts, :foreign_key, nil)

    quote do
      import OOTPUtility.Statistics.Batting.Player.Schema

      use OOTPUtility.Statistics.Batting.Schema,
        composite_key: unquote(composite_key),
        foreign_key: unquote(foreign_key)
    end
  end

  defmacro player_batting_schema(source, do: block) do
    quote do
      batting_schema unquote(source) do
        field :ubr, :float
        field :war, :float
        field :wpa, :float

        belongs_to :player, Players.Player

        unquote(block)
      end
    end
  end
end
