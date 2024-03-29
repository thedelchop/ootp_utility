defmodule OOTPUtilityWeb.Components.Shared.SectionHeader do
  @moduledoc """
  A TailwindUI HTML Section or Card Header.
  """
  use Surface.Component

  slot default, required: true

  def render(assigns) do
    ~F"""
    <div class="bg-gray-50 pb-2 border-b border-gray-200 grow">
      <h3 class="text-lg p-2 font-medium text-gray-900">
        <#slot />
      </h3>
    </div>
    """
  end
end
