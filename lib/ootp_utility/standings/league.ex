defmodule OOTPUtility.Standings.League do
  @type t() :: %__MODULE__{}

  use Ecto.Schema
  use OOTPUtility.Collectable

  alias OOTPUtility.{Leagues, Repo}
  alias OOTPUtility.Standings.Conference

  alias __MODULE__

  embedded_schema do
    field :name, :string
    field :abbr, :string

    embeds_many :conference_standings, Conference
  end

  def new(%Leagues.League{conferences: nil} = league) do
    league
    |> Repo.preload(conferences: [divisions: [teams: [:record]]])
    |> new()
  end

  def new(
        %Leagues.League{
          name: name,
          abbr: abbr,
          conferences: conferences
        } = _league
      ) do
    %League{
      name: name,
      abbr: abbr,
      conference_standings: Enum.map(conferences, &Conference.new/1)
    }
  end
end
