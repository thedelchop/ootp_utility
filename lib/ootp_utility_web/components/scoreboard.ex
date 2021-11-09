defmodule OOTPUtilityWeb.Components.Scoreboard do
  use Surface.Component

  alias OOTPUtilityWeb.Components.Scoreboard.Game

  prop games, :list, required: true

  def render(assigns) do
    ~F"""
      <div class="flex bg-gray-200 p-2 justify-evenly rounded-md">
        {#for game <- Enum.take(@games, 9)}
          <Game id={game.id} game={game} />
        {/for}
      </div>
    """
  end
end
