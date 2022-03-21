defmodule OOTPUtilityWeb.Components.Player.Details do
  use Surface.Component

  prop player, :struct

  def render(assigns) do
    ~F"""
    <dl class="hidden lg:block pl-4">
      <div class="grid grid-cols-3 gap-1 p-0.5">
        <dt class="text-sm font-medium text-gray-500">
          HT/WT:
        </dt>
        <dd class="text-sm tracking-wider text-gray-900 col-span-2">
          {height(@player)}/{"#{@player.weight} lbs"}
        </dd>
      </div>
      <div class="grid grid-cols-3 gap-1 p-0.5">
        <dt class="text-sm font-medium text-gray-500">
          DOB:
        </dt>
        <dd class="text-sm tracking-wider text-gray-900 col-span-2">
          {Timex.format!(@player.date_of_birth, "{0M}/{0D}/{YYYY}")} ({@player.age})
        </dd>
      </div>
      <div class="grid grid-cols-3 gap-1 p-0.5">
        <dt class="text-sm tracking-wider font-medium text-gray-500">
          B/T
        </dt>
        <dd class="text-sm tracking-wider text-gray-900 col-span-2">
          {String.capitalize(@player.bats)}/{String.capitalize(@player.throws)}
        </dd>
      </div>
    </dl>
    """
  end

  def height(player) do
    height_inches = ceil(player.height / 100 * 39.37)

    height_ft = div(height_inches, 12)
    height_in = rem(height_inches, 12)

    "#{height_ft}' #{height_in}\""
  end
end
