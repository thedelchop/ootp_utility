defmodule OOTPUtility.Standings.Conference do
  use Ecto.Schema
  use OOTPUtility.Collectable

  alias OOTPUtility.{Leagues, Repo}
  alias OOTPUtility.Standings.{Division, Team}

  alias __MODULE__

  embedded_schema do
    field :name, :string
    field :abbr, :string
    field :conference_id, :string

    embeds_many :division_standings, Division
    embeds_many :team_standings, Team
  end

  def new(%Leagues.Conference{divisions: %Ecto.Association.NotLoaded{}} = conference) do
    conference
    |> Repo.preload(divisions: [teams: [:record]])
    |> new()
  end

  def new(%Leagues.Conference{divisions: [], teams: %Ecto.Association.NotLoaded{}} = conference) do
    conference
    |> Repo.preload(teams: [:record])
    |> new()
  end

  def new(
        %Leagues.Conference{
          name: name,
          abbr: abbr,
          divisions: [],
          teams: teams,
          slug: conference_id
        } = _conference
      ) do
    %Conference{
      name: name,
      abbr: abbr,
      conference_id: conference_id,
      team_standings: Enum.map(teams, &Team.new/1)
    }
  end

  def new(
        %Leagues.Conference{
          name: name,
          abbr: abbr,
          divisions: divisions,
          slug: conference_id
        } = _conference
      ) do
    %Conference{
      name: name,
      abbr: abbr,
      conference_id: conference_id,
      division_standings: Enum.map(divisions, &Division.new/1)
    }
  end
end
