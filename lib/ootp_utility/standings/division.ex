defmodule OOTPUtility.Standings.Division do
  use Ecto.Schema
  use OOTPUtility.Collectable

  alias OOTPUtility.{Leagues, Repo}
  alias OOTPUtility.Standings.Team

  alias __MODULE__

  embedded_schema do
    embeds_one :division, Leagues.Division

    embeds_many :team_standings, Team
  end

  def name(%Division{division: %Leagues.Division{name: name}}), do: name
  def division_id(%Division{division: %Leagues.Division{slug: slug}}), do: slug

  def new(%Leagues.Division{teams: nil} = division) do
    division
    |> Repo.preload(teams: [:record])
    |> new()
  end

  def new(
        %Leagues.Division{
          teams: teams,
        } = division
      ) do
    team_standings =
      teams
      |> Enum.map(&Team.new/1)
      |> Enum.sort(&(&2.position > &1.position))

    %Division{
      division: division,
      team_standings: team_standings
    }
  end
end
