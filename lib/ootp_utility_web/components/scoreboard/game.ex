defmodule OOTPUtilityWeb.Components.Scoreboard.Game do
  use Surface.LiveComponent

  alias OOTPUtility.Teams.Team
  alias OOTPUtility.Games.Game
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  prop game, :struct, required: true

  def render(assigns) do
    ~F"""
      <div class="flex flex-col overflow-hidden flex-none bg-white border p-1 mx-1 rounded-lg">
        {team_summary(@socket, @game.away_team)}
        {team_summary(@socket, @game.home_team)}
        <hr />
        <div class="text-xs text-gray-500 text-center tracking-tighter px-0.5 py-1">{start_time(@game)}</div>
      </div>
    """
  end

  def team_summary(socket, %Team{logo_filename: logo, abbr: abbr} = team) do
    assigns = assign(%{__changed__: %{}}, logo: logo, abbr: abbr, record: team_record(team))

    ~F"""
      <div class="flex p-0.5">
        <img class="h-5 w-5 mt-0.5" src={Routes.static_path(socket, "/images/logos/#{logo}")} alt="">
        <h4 class="text-base tracking-tighter mx-1">{@abbr}</h4>
        <h5 class="flex-grow flex-shrink-0 text-small text-gray-400 text-right ml-2">{@record}</h5>
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
