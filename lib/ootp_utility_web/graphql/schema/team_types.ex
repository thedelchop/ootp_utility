defmodule OOTPUtility.Schema.TeamTypes do
  use Absinthe.Schema.Notation

  alias OOTPUtility.GraphQL.Resolvers

  object :team do
    field :id, :id
    field :name, :string
    field :abbr, :string
    field :level, :string

    field :record, :team_record do
      resolve &Resolvers.Teams.find_record/3
    end
  end
end
