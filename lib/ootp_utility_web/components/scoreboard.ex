defmodule OOTPUtilityWeb.Components.Scoreboard do
  use Surface.Component

  alias OOTPUtilityWeb.Components.Scoreboard.Game

  prop games, :list, required: true

  def render(assigns) do
    ~F"""
      <div class="scoreboard flex">
        {#for game <- @games}
          <Game id={game.id} game={game} />
        {/for}
      </div>
    """
  end
end
