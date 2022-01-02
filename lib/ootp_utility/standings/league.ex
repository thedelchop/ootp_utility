defmodule OOTPUtility.Standings.League do
  use Ecto.Schema
  use OOTPUtility.Collectable

  alias OOTPUtility.Leagues
  alias OOTPUtility.Standings

  @derive {Inspect,
           only: [:id, :league, :conference_standings, :division_standings, :team_standings]}

  embedded_schema do
    embeds_one :league, Leagues.League

    embeds_many :conference_standings, Standings.Conference
    embeds_many :division_standings, Standings.Division
    embeds_many :team_standings, Standings.Team
  end

  def name(%Standings.League{league: %Leagues.League{name: name}}), do: name
  def slug(%Standings.League{league: %Leagues.League{slug: slug}}), do: slug
  def league_id(%Standings.League{league: %Leagues.League{slug: slug}}), do: slug

  def new(
        %Leagues.League{
          conferences: [],
          divisions: [],
          teams: teams
        } = league
      ) do
    %Standings.League{
      id: "#{league.slug}-standings",
      league: league,
      conference_standings: [],
      division_standings: [],
      team_standings: Enum.map(teams, &Standings.for_team/1)
    }
  end

  def new(
        %Leagues.League{
          conferences: [],
          divisions: divisions
        } = league
      ) do
    %Standings.League{
      id: "#{league.slug}-standings",
      league: league,
      conference_standings: [],
      division_standings: Enum.map(divisions, &Standings.for_division/1)
    }
  end

  def new(%Leagues.League{conferences: conferences} = league) do
    %Standings.League{
      id: "#{league.slug}-standings",
      league: league,
      division_standings: [],
      conference_standings: Enum.map(conferences, &Standings.for_conference/1)
    }
  end
end
