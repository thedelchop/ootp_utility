defmodule OOTPUtility.Standings.League do
  use Ecto.Schema
  use OOTPUtility.Collectable

  alias OOTPUtility.{Leagues, Repo}
  alias OOTPUtility.Standings.{Conference, Division}

  alias __MODULE__

  embedded_schema do
    field :name, :string
    field :abbr, :string
    field :league_id, :string

    embeds_many :conference_standings, Conference
    embeds_many :division_standings, Division
  end

  def new(%Leagues.League{conferences: %Ecto.Association.NotLoaded{}} = league) do
    league
    |> Repo.preload(conferences: [divisions: [teams: [:record]]])
    |> new()
  end

  def new(%Leagues.League{conferences: [], divisions: %Ecto.Association.NotLoaded{}} = league) do
    league
    |> Repo.preload(divisions: [teams: [:record]])
    |> new()
  end

  def new(
        %Leagues.League{
          name: name,
          abbr: abbr,
          conferences: [],
          divisions: divisions,
          id: league_id
        } = _league
      ) do
    %League{
      name: name,
      abbr: abbr,
      league_id: league_id,
      conference_standings: [],
      division_standings: Enum.map(divisions, &Division.new/1)
    }
  end

  def new(
        %Leagues.League{
          name: name,
          abbr: abbr,
          conferences: conferences,
          id: league_id
        } = _league
      ) do
    %League{
      name: name,
      abbr: abbr,
      league_id: league_id,
      division_standings: [],
      conference_standings: Enum.map(conferences, &Conference.new/1)
    }
  end
end
