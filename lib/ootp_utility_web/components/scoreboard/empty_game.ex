defmodule OOTPUtilityWeb.Components.Scoreboard.EmptyGame do
  use Surface.Component

  def render(assigns) do
    ~F"""
      <div class="flex flex-col flex-none animate-pulse bg-white border p-2 mx-1 rounded-lg w-32">
        <div class="mb-1 space-y-1.5">
          <div class="flex">
            <div class="h-4 w-4 bg-gray-100 rounded-full"></div>
            <div class="flex-grow flex-shrink-0 ml-2 mt-0.5 bg-gray-100 h-3 rounded-md"></div>
          </div>
          <div class="flex">
            <div class="h-4 w-4 bg-gray-100 rounded-full"></div>
            <div class="flex-grow flex-shrink-0 ml-2 mt-0.5 bg-gray-100 h-3 rounded-md"></div>
          </div>
        </div>
        <hr class="my-2" />
        <div class="flex flex-col flex-grow space-y-2">
          <div class="bg-gray-100 h-3 rounded-md"></div>
          <div class="bg-gray-100 h-3 rounded-md"></div>
        </div>
      </div>
    """
  end
end
