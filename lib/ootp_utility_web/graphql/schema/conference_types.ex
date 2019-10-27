defmodule OOTPUtility.Schema.ConferenceTypes do
  use Absinthe.Schema.Notation

  alias OOTPUtility.GraphQL.Resolvers

  object :conference do
    field :id, :id
    field :name, :string
    field :abbr, :string
    field :designated_hitter, :boolean

    field :divisions, list_of(:division) do
      resolve &Resolvers.Divisions.list_divisions/3
    end
  end
end
