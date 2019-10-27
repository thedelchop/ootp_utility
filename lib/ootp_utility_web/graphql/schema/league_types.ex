defmodule OOTPUtility.Schema.LeagueTypes do
  use Absinthe.Schema.Notation

  alias OOTPUtility.GraphQL.Resolvers

  object :league do
    field :id, :id
    field :name, :string
    field :abbr, :string
    field :current_date, :date
    field :historical_year, :integer
    field :league_level, :string
    field :league_state, :string
    field :season_year, :integer
    field :start_date, :date

    field :conferences, list_of(:conference) do
      resolve &Resolvers.Conferences.list_conferences/3
    end
  end
end

