defmodule OOTPUtility.Collectable do
  defmacro __using__(_opts) do
    quote do
      defimpl Collectable, for: __MODULE__ do
        def into(original) do
          {original,
           fn
             map, {:cont, {k, v}} -> :maps.put(k, v, map)
             map, :done -> map
             _, :halt -> :ok
           end}
        end
      end
    end
  end
end
