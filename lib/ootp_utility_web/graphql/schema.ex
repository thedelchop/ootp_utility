defmodule OOTPUtility.GraphQL.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom
  import_types OOTPUtility.Schema.TeamTypes
  import_types OOTPUtility.Schema.LeagueTypes
  import_types OOTPUtility.Schema.ConferenceTypes
  import_types OOTPUtility.Schema.DivisionTypes
  import_types OOTPUtility.Schema.Team.RecordTypes

  alias OOTPUtility.GraphQL.Resolvers

  query do
    @desc "Get all teams"
    field :teams, list_of(:team) do
      resolve &Resolvers.Teams.list_teams/3
    end

    @desc "Get all leagues"
    field :leagues, list_of(:league) do
      resolve &Resolvers.Leagues.list_leagues/3
    end

    @desc "Get a specific league"
    field :league, :league do
      arg :id, non_null(:id)
      resolve &Resolvers.Leagues.find_league/3
    end
  end
end
