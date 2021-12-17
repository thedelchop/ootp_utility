defmodule OOTPUtilityWeb.Components.Shared.SectionHeader do
  @moduledoc """
  A TailwindUI HTML Section or Card Header.
  """
  use Surface.Component

  slot default, required: true

  def render(assigns) do
    ~F"""
      <div class="bg-gray-50 pb-4 border-b border-gray-200">
        <h3 class="text-lg font-medium text-gray-900">
          <#slot />
        </h3>
      </div>
    """
  end
end
