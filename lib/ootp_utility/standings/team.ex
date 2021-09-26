defmodule OOTPUtility.Standings.Team do
  use Ecto.Schema
  use OOTPUtility.Collectable

  alias OOTPUtility.{Repo, Teams}
  alias __MODULE__

  embedded_schema do
    field :logo_filename, :string
    field :name, :string
    field :abbr, :string

    field :games, :integer
    field :games_behind, :float
    field :losses, :integer
    field :magic_number, :integer
    field :position, :integer
    field :streak, :integer
    field :winning_percentage, :float
    field :wins, :integer
  end

  def new(%Teams.Team{record: nil} = team) do
    team
    |> Repo.preload(:record)
    |> new()
  end

  def new(
        %Teams.Team{
          name: name,
          abbr: abbr,
          logo_filename: logo,
          record: team_record
        } = _team
      ) do
    team_record
    |> Map.from_struct()
    |> Map.drop([:team_id])
    |> Enum.into(%Team{
      name: name,
      abbr: abbr,
      logo_filename: logo
    })
  end
end
