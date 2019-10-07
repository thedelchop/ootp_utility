defmodule OOTPUtility.Leagues do
  alias OOTPUtility.{League, Repo}
  alias OOTPUtility.Leagues.{Conference, Division}

  import Ecto.Query, only: [from: 2]

  def find_league(id), do: Repo.get(League, id)

  def list_leagues, do: Repo.all(League)

  def list_conferences(league) do
    Repo.all(from(c in Conference, where: c.league_id == ^league.id))
  end

  def list_divisions(conference) do
    Repo.all(from(d in Division, where: d.conference_id == ^conference.id))
  end
end
