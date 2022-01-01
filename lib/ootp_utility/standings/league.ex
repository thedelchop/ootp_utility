defmodule OOTPUtility.Standings.League do
  use Ecto.Schema
  use OOTPUtility.Collectable

  alias OOTPUtility.Leagues
  alias OOTPUtility.Standings.{Conference, Division}

  alias __MODULE__

  @derive {Inspect, only: [:id, :league, :conference_standings, :division_standings]}

  embedded_schema do
    embeds_one :league, Leagues.League

    embeds_many :conference_standings, Conference
    embeds_many :division_standings, Division
  end

  def name(%League{league: %Leagues.League{name: name}}), do: name
  def slug(%League{league: %Leagues.League{slug: slug}}), do: slug
  def league_id(%League{league: %Leagues.League{slug: slug}}), do: slug

  def new(
        %Leagues.League{
          conferences: [],
          divisions: divisions
        } = league
      ) do
    %League{
      id: "#{league.slug}-standings",
      league: league,
      conference_standings: [],
      division_standings: Enum.map(divisions, &Division.new/1)
    }
  end

  def new(%Leagues.League{conferences: conferences} = league) do
    %League{
      id: "#{league.slug}-standings",
      league: league,
      division_standings: [],
      conference_standings: Enum.map(conferences, &Conference.new/1)
    }
  end
end
