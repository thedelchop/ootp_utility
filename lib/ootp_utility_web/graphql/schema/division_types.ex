defmodule OOTPUtility.Schema.DivisionTypes do
  use Absinthe.Schema.Notation

  alias OOTPUtility.GraphQL.Resolvers

  object :division do
    field :id, :id
    field :name, :string

    field :conference, :conference do
      resolve &Resolvers.Conferences.find_conference/3
    end

    field :league, :league do
      resolve &Resolvers.Leagues.find_league/3
    end

    field :teams, list_of(:team) do
      resolve &Resolvers.Teams.list_teams/3
    end
  end
end
