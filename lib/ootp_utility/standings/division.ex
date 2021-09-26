defmodule OOTPUtility.Standings.Division do
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
    team_standings =
      teams
      |> Enum.map(&Team.new/1)
      |> Enum.sort(&(&2.position > &1.position))

    %Division{
      name: name,
      team_standings: team_standings
    }
  end
end
