defmodule OOTPUtility.Standings.Conference do
  @type t() :: %__MODULE__{}

  use Ecto.Schema
  use OOTPUtility.Collectable

  alias OOTPUtility.{Leagues, Repo}
  alias OOTPUtility.Standings.Division

  alias __MODULE__

  embedded_schema do
    field :name, :string
    field :abbr, :string

    embeds_many :division_standings, Division
  end

  def new(%Leagues.Conference{divisions: nil} = conference) do
    conference
    |> Repo.preload(divisions: [teams: [:record]])
    |> new()
  end

  def new(
        %Leagues.Conference{
          name: name,
          abbr: abbr,
          divisions: divisions
        } = _conference
      ) do
    %Conference{
      name: name,
      abbr: abbr,
      division_standings: Enum.map(divisions, &Division.new/1)
    }
  end
end
