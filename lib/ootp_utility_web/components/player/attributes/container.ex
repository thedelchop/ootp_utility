defmodule OOTPUtilityWeb.Components.Player.Attributes.Container do
  use Surface.Component

  prop title, :string, default: ""
  prop attributes, :keyword, required: true

  def render(assigns) do
    ~F"""
    <div class="grow">
      <div class="flex flex-col divide-y divide-gray-200">
        <div class="bg-gray-100 p-1 md:p-2 uppercase font-small md:font-medium text-left">{@title}</div>
        {#for {name, ratings} <- @attributes}
          {#for {_type, rating} <- ratings}
            <div class="flex justify-between p-1 md:p-2">
              <div>{attribute_name(name)}</div>
              <div>{as_number(rating)}</div>
            </div>
          {/for}
        {/for}
      </div>
    </div>
    """
  end

  def attribute_name(attribute), do: OOTPUtilityWeb.Helpers.capitalize_all(attribute)

  def as_number(nil) do
    assigns = %{rating: nil}

    ~F"""
      <span>-</span>
    """
  end

  def as_number(rating) do
    assigns = %{rating: rating}

    ~F"""
      <span class={"text-rating-#{@rating * 2}"}>{@rating}</span>
    """
  end
end
