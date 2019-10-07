defmodule OOTPUtility.GraphQL.Resolvers.Leagues do
  alias OOTPUtility.Leagues

  def find_league(_parent, %{id: id}, _resolution) do 
    case Leagues.find_league(id) do
      nil ->
        {:error, "League with ID #{id} not found"}
      league ->
        {:ok, league}
    end
  end

  def find_league(%Leagues.Conference{} = conference, _args, _resolution) do 
    case Leagues.find_league(conference.league_id) do
      nil ->
        {:error, "The league associated with this conference: #{conference.league_id} could not be found"}
      league ->
        {:ok, league}
    end
  end

  def find_league(%Leagues.Division{} = division, _args, _resolution) do 
    case Leagues.find_league(division.league_id) do
      nil ->
        {:error, "The league associated with this division: #{division.league_id} could not be found"}
      league ->
        {:ok, league}
    end
  end

  def list_leagues(_parent, _args, _resolution), do: {:ok, Leagues.list_leagues()}
end
