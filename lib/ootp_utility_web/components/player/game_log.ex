defmodule OOTPUtilityWeb.Components.Player.GameLog do
  use Surface.LiveComponent

  alias OOTPUtility.{Players, Statistics}
  alias OOTPUtilityWeb.Components.Shared.{Section, Table}
  alias OOTPUtilityWeb.Components.Shared.Table.Column
  alias OOTPUtilityWeb.Components.Player.Attributes.Helpers

  import OOTPUtilityWeb.Helpers, only: [display_size: 1]

  prop player, :struct, required: true

  @impl true
  def render(assigns) do
    ~F"""
    <Section event_target={@socket.id}>
      <Table
        id="player-game-log"
        data={game_log <- game_logs_for(@player)}
        header_class={&header_class/2}
        column_class={&column_class/2}
      >
        <Column label="Date">
        </Column>

        <Column label="Opponent">
        </Column>

        <Column label="Result">
        </Column>

        <Column label="AB">
        </Column>

        <Column label="R">
        </Column>

        <Column label="H">
        </Column>

        <Column label="2B">
        </Column>

        <Column label="3B">
        </Column>

        <Column label="HR">
        </Column>

        <Column label="RBI">
        </Column>

        <Column label="BB">
        </Column>

        <Column label="SO">
        </Column>

        <Column label="SB">
        </Column>

        <Column label="CS">
        </Column>

        <Column label="AVG">
        </Column>

        <Column label="OBP">
        </Column>

        <Column label="SLG">
        </Column>
      </Table>
    </Section>
    """
  end

  def game_logs_for(%Players.Player{league: %Ecto.Association.NotLoaded{}} = player) do
    player
    |> Repo.preload(:league)
    |> game_logs_for()
  end

  def game_logs_for(%Players.Player{league: league} = player) do
    Statistics.game_logs_for(player, before: league.current_date)
  end

  @impl true
  def handle_event("viewport_resize", viewport, socket) do
    {:noreply, assign(socket, :size, display_size(viewport))}
  end

  def header_class(attribute, index) when index in [2, 3] do
    Helpers.header_class(attribute, index) ++ ["hidden", "md:table-cell"]
  end

  def header_class(attr, index), do: Helpers.header_class(attr, index)

  def column_class(attribute, index) when index in [2, 3] do
    Helpers.column_class(attribute, index) ++ ["hidden", "md:table-cell"]
  end

  def column_class(attr, index), do: Helpers.column_class(attr, index)
end
