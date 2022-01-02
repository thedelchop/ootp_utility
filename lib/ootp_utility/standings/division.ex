defmodule OOTPUtility.Standings.Division do
  use Ecto.Schema
  use OOTPUtility.Collectable

  alias OOTPUtility.{Leagues, Standings}

  alias __MODULE__

  @derive {Inspect, only: [:id, :division, :team_standings]}

  embedded_schema do
    embeds_one :division, Leagues.Division

    embeds_many :team_standings, Standings.Team
  end

  def new(
        %Leagues.Division{
          teams: teams
        } = division
      ) do
    team_standings =
      teams
      |> Enum.map(&Standings.for_team/1)
      |> Enum.sort(&(&2.position > &1.position))

    %Division{
      id: "#{division.slug}-standings",
      division: division,
      team_standings: team_standings
    }
  end
end
