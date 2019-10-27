defmodule OOTPUtility.GraphQL.Resolvers.Conferences do
  alias OOTPUtility.{League, Leagues, Conferences}

  def find_conference(%Leagues.Division{} = division, _args, _resolution) do
    {:ok, Conferences.find_conference(division.conference_id) }
  end

  def list_conferences(%League{} = league, _args, _resolution), do: {:ok, Leagues.list_conferences(league)}
end

