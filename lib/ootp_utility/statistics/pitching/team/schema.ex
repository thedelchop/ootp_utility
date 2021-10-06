defmodule OOTPUtility.Statistics.Pitching.Team.Schema do
  defmacro __using__([{:table, table}]) do
    quote do
      use OOTPUtility.Statistics.Pitching.Schema,
        composite_key: [:team_id, :year],
        foreign_key: [:id, :year]

      pitching_schema unquote(table) do
        field :fielding_independent_pitching, :float
      end
    end
  end
end
