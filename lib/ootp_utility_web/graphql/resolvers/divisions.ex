defmodule OOTPUtility.GraphQL.Resolvers.Divisions do
  alias OOTPUtility.Leagues

  def list_divisions(%Leagues.Conference{} = conference, _args, _resolution), do: {:ok, Leagues.list_divisions(conference)}
end
