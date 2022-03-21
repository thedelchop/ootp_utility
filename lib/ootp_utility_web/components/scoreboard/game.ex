defmodule OOTPUtilityWeb.Components.Scoreboard.Game do
  use Surface.LiveComponent

  alias OOTPUtility.{Games, Players, Repo, Standings, Teams}
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  prop game, :struct, required: true

  def render(assigns) do
    ~F"""
    <div class="flex flex-col flex-none bg-white border border-gray-200 p-2 rounded-lg w-32 shadow">
      {team_summary(@socket, @game, :away_team)}
      {team_summary(@socket, @game, :home_team)}
      <hr class="my-2">
      <div class={"text-xs", "text-gray-500", "tracking-tighter", "px-0.5", "text-center": not is_played?(@game)}>
        {if is_played?(@game), do: results(@game), else: start_time(@game)}
      </div>
    </div>
    """
  end

  def results(
        %Games.Game{
          winning_pitcher: winning_pitcher,
          losing_pitcher: losing_pitcher,
          save_pitcher: save_pitcher
        } = _game
      ) do
    assigns =
      %{__changed__: %{}}
      |> assign(
        winning_pitcher: Players.name(winning_pitcher, :short),
        losing_pitcher: Players.name(losing_pitcher, :short),
        save_pitcher: Players.name(save_pitcher, :short)
      )

    ~F"""
    <dl>
      <div class="flex">
        <dt class="text-xs">W:</dt>
        <dd class="flex-grow text-xs text-right">{@winning_pitcher}</dd>
      </div>
      <div class="flex">
        <dt class="text-xs">L:</dt>
        <dd class="flex-grow text-right text-xs">{@losing_pitcher}</dd>
      </div>
      {#if not is_nil(@save_pitcher)}
        <div class="flex">
          <dt class="text-xs">S:</dt>
          <dd class="flex-grow text-right text-xs">{@save_pitcher}</dd>
        </div>
      {/if}
    </dl>
    """
  end

  def is_played?(%Games.Game{played: played}), do: played

  def team_summary(socket, %Games.Game{played: false} = game, team_type) do
    %Teams.Team{logo_filename: logo, abbr: abbr} = team = Map.get(game, team_type)

    %{__changed__: %{}}
    |> assign(
      logo: logo,
      abbr: abbr,
      record_or_score: team_record(team),
      socket: socket
    )
    |> render_team_summary()
  end

  def team_summary(socket, %Games.Game{played: true} = game, team_type) do
    %Teams.Team{logo_filename: logo, abbr: abbr} = Map.get(game, team_type)
    runs_scored = Map.get(game, :"#{team_type}_runs")

    %{__changed__: %{}}
    |> assign(
      logo: logo,
      abbr: abbr,
      record_or_score: runs_scored,
      socket: socket
    )
    |> render_team_summary()
  end

  defp render_team_summary(assigns) do
    ~F"""
    <div class="flex">
      <img class="h-5 w-5" src={Routes.static_path(@socket, "/images/logos/#{@logo}")} alt="">
      <h4 class="text-sm tracking-tighter mx-1">{@abbr}</h4>
      <h5 class="flex-grow flex-shrink-0 text-xs text-gray-400 text-right ml-2">{@record_or_score}</h5>
    </div>
    """
  end

  defp start_time(%Games.Game{date: date, time: time} = _game) do
    gametime = DateTime.new!(date, time)

    Timex.format!(gametime, "{0M}/{0D} {0h12}:{0m} {AM}")
  end

  def team_record(%Teams.Team{record: %Ecto.Association.NotLoaded{}} = team) do
    team
    |> Repo.preload(:record)
    |> team_record()
  end

  def team_record(%Teams.Team{record: %Standings.TeamRecord{wins: wins, losses: losses}} = _team) do
    "#{wins}-#{losses}"
  end
end
