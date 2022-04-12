defmodule OOTPUtility.Imports.ImportAgent do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def put_cache(cache_id, items) do
    Agent.update(__MODULE__, fn state ->
      existing_items = Map.get(state, cache_id, [])

      Map.put(state, cache_id, existing_items ++ items)
    end)
  end

  def get_cache(cache_id) do
    Agent.get(__MODULE__, fn state ->
      Map.get(state, cache_id, [])
    end)
  end

  def in_cache?(_cache_id, nil), do: true

  def in_cache?(cache_id, item_id) do
    cache_id
    |> get_cache()
    |> Enum.member?(item_id)
  end
end
