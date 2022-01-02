defmodule OOTPUtility.Standings.Conference do
  use Ecto.Schema
  use OOTPUtility.Collectable

  alias OOTPUtility.{Leagues, Standings}

  @derive {Inspect, only: [:id, :conference, :division_standings, :team_standings]}

  embedded_schema do
    embeds_one :conference, Leagues.Conference

    embeds_many :division_standings, Standings.Division
    embeds_many :team_standings, Standings.Team
  end

  def name(%Standings.Conference{conference: %Leagues.Conference{name: name}}), do: name
  def slug(%Standings.Conference{conference: %Leagues.Conference{slug: slug}}), do: slug

  def new(
        %Leagues.Conference{
          divisions: [],
          teams: teams
        } = conference
      ) do
    %Standings.Conference{
      id: "#{conference.slug}-standings",
      conference: conference,
      team_standings: Enum.map(teams, &Standings.for_team/1)
    }
  end

  def new(%Leagues.Conference{divisions: divisions} = conference) do
    %Standings.Conference{
      id: "#{conference.slug}-standings",
      conference: conference,
      division_standings: Enum.map(divisions, &Standings.for_division/1)
    }
  end
end
