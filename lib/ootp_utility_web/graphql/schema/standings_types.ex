defmodule OOTPUtility.Schema.StandingsTypes do
  use Absinthe.Schema.Notation

  alias OOTPUtility.GraphQL.Resolvers

  object :division_standings, list_of(:division_standings) do
    resolve &Resolvers.Divisions.list_division_standings/3
  end

  field :conference_standings, list_of(:division_standings) do
    resolve &Resolvers.Divisions.list_division_standings/3
  end


  field :league_standings, list_of(:conference_standings) do
    resolve &Resolvers.Conferences.list_confernence_standings/3
  end
end


