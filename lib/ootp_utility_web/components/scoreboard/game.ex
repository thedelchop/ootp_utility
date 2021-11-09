defmodule OOTPUtilityWeb.Components.Scoreboard.Game do
  use Surface.LiveComponent

  alias OOTPUtility.Teams.Team
  alias OOTPUtility.Games.Game
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  prop game, :struct, required: true

  def render(assigns) do
    ~F"""
      <div class="game-summary flex flex-column">
        {team_summary(@socket, @game.away_team)}
        {team_summary(@socket, @game.home_team)}
        <hr />
        <div>{start_time(@game)}</div>
      </div>
    """
  end

  def team_summary(socket, %Team{logo_filename: logo, abbr: abbr} = team) do
    assigns = assign(%{}, logo: logo, abbr: abbr, record: team_record(team))

    ~H"""
      <div class="inline-flex justify-start">
        <img class="h-3 w-3 rounded-full" src={Routes.static_path(socket, "/images/logos/#{logo}")} alt="">
        <h4 class="text-base">{@abbr}</h4>
        <h5 class="text-small text-gray-400 justify-self-end">{@record}</h5>
      </div>
    """
  end

  defp start_time(%Game{} = _game) do
    "Mon, 7/23 8:OO PM"
  end

  def team_record(%Team{} = _team) do
    wins = Enum.random(72..105)

    losses = 162 - wins

    "#{wins}-#{losses}"
  end
end
