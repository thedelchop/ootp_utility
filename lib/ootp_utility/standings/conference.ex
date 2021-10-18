defmodule OOTPUtility.Standings.Conference do
  use Ecto.Schema
  use OOTPUtility.Collectable

  alias OOTPUtility.{Leagues, Repo}
  alias OOTPUtility.Standings.{Division, Team}

  alias __MODULE__

  embedded_schema do
    embeds_one :conference, Leagues.Conference

    embeds_many :division_standings, Division
    embeds_many :team_standings, Team
  end

  def name(%Conference{conference: %Leagues.Conference{name: name}}), do: name
  def slug(%Conference{conference: %Leagues.Conference{slug: slug}}), do: slug

  def new(%Leagues.Conference{divisions: %Ecto.Association.NotLoaded{}} = conference) do
    conference
    |> new()
  end

  def new(%Leagues.Conference{divisions: [], teams: %Ecto.Association.NotLoaded{}} = conference) do
    conference
    |> Repo.preload(teams: [:record])
    |> new()
  end

  def new(
        %Leagues.Conference{
          divisions: [],
          teams: teams
        } = conference
      ) do
    %Conference{
      conference: conference,
      team_standings: Enum.map(teams, &Team.new/1)
    }
  end

  def new(%Leagues.Conference{divisions: divisions} = conference) do
    %Conference{
      conference: conference,
      division_standings: Enum.map(divisions, &Division.new/1)
    }
  end
end
