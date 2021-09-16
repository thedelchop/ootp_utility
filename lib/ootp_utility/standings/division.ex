defmodule OOTPUtility.Standings.Division do
  @type t() :: %__MODULE__{}

  use Ecto.Schema
  use OOTPUtility.Collectable

  alias OOTPUtility.{Leagues, Repo}
  alias OOTPUtility.Standings.Team

  alias __MODULE__

  embedded_schema do
    field :name, :string
    embeds_many :team_standings, Team
  end

  def new(%Leagues.Division{teams: nil} = division) do
    division
    |> Repo.preload(teams: [:record])
    |> new()
  end

  def new(
        %Leagues.Division{
          name: name,
          teams: teams
        } = _division
      ) do
     %Division{
      name: name,
      team_standings: Enum.map(teams, fn team ->
        Team.new(team)
      end)
    }
  end
end
