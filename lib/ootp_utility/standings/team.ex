defmodule OOTPUtility.Standings.Team do
  use Ecto.Schema
  use OOTPUtility.Collectable

  alias OOTPUtility.{Standings, Teams}

  @derive {Inspect,
           only: [
             :id,
             :name,
             :games,
             :wins,
             :losses,
             :winning_percentage,
             :position,
             :games_behind
           ]}

  embedded_schema do
    field :logo_filename, :string
    field :name, :string
    field :abbr, :string
    field :slug, :string

    field :games, :integer
    field :games_behind, :float
    field :losses, :integer
    field :magic_number, :integer
    field :position, :integer
    field :streak, :integer
    field :winning_percentage, :float
    field :wins, :integer
  end

  def new(
        %Teams.Team{
          slug: slug,
          abbr: abbr,
          logo_filename: logo,
          record:
            %Standings.TeamRecord{
              games: games,
              games_behind: games_behind,
              losses: losses,
              magic_number: magic_number,
              position: position,
              streak: streak,
              winning_percentage: winning_percentage,
              wins: wins
            } = _team_record
        } = team
      ) do
    %Standings.Team{
      id: "#{slug}-standings",
      name: Teams.get_full_name(team),
      abbr: abbr,
      slug: slug,
      logo_filename: logo,

      games: games,
      wins: wins,
      losses: losses,
      games_behind: games_behind,
      winning_percentage: winning_percentage,
      position: position,
      streak: streak,
      magic_number: magic_number
    }
  end
end
