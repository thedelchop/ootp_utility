defmodule OOTPUtility.GraphQL.Resolvers.Teams do
  alias OOTPUtility.{Teams,Team,Leagues}

  def list_teams(%Leagues.Division{} = division, _args, _resolution) do
    {:ok, Teams.list_teams(division)}
  end

  def list_teams(_parent, _args, _resolution), do: {:ok, Teams.list_teams()}

  def find_record(%Team{} = team, _args, _resolution) do
    {:ok, Teams.find_record(team)}
  end
end
