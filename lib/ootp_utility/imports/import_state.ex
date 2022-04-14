defmodule OOTPUtility.Imports.ImportState do
  use GenServer

  def start_link({session, dependency_graph}) do
    GenServer.start_link(__MODULE__, dependency_graph, name: via(session))
  end

  def init(dependency_graph) do
    {
      :ok,
      %{
        finished: false,
        dependencies: dependency_graph,
        available: [],
        processing: [],
        failed: [],
        completed: []
      }
    }
  end

  defp via(session) do
    {
      :via,
      Registry,
      {OOTPUtility.Imports.StateRegistry, session}
    }
  end

  def available_for_import(session),
    do: GenServer.call(via(session), :available_for_import)

  def import_completed(session, module),
    do: GenServer.call(via(session), {:import_completed, module})

  def import_failed(session, module), do: GenServer.call(via(session), {:import_failed, module})

  def import_started(session, module),
    do: GenServer.call(via(session), {:import_started, module})

  def import_available(session, module),
    do: GenServer.call(via(session), {:import_available, module})

  def finished?(session), do: GenServer.call(via(session), :finished?)

  def handle_call(:finished?, _from, %{finished: finished} = state) do
    {:reply, finished, state}
  end

  def handle_call(:available_for_import, _from, %{available: available} = state) do
    {:reply, available, state}
  end

  def handle_call({:import_available, module}, _from, %{available: available} = state) do
    new_state = %{state | available: [module | available]}

    {:reply, module, new_state}
  end

  def handle_call({:import_started, module}, _from, state) do
    new_state = transition_import(module, :available, :processing, state)

    {:reply, module, new_state}
  end

  def handle_call(
        {:import_completed, module},
        _from,
        %{dependencies: dependency_graph, available: available} = state
      ) do
    state = transition_import(module, :processing, :completed, state)

    case dependents_of(module, dependency_graph) do
      [] ->
        state = maybe_mark_complete(state)

        {:reply, :ok, state}

      dependents ->
        {:reply, :ok, %{state | available: available ++ dependents}}
    end
  end

  def handle_call({:import_failed, module}, _from, state) do
    state = transition_import(module, :processing, :failed, state)

    {:reply, state, state}
  end

  def handle_call(
        :process_next_available,
        _from,
        %{
          available: [next | rest],
          processing: processing
        } = state
      ) do
    new_state = %{
      state
      | available: rest,
        processing: [next | processing]
    }

    {:reply, next, new_state}
  end

  defp maybe_mark_complete(
         %{
           dependencies: graph,
           available: [],
           processing: [],
           completed: completed,
           failed: failed
         } = state
       ) do
    case Enum.sort(Graph.vertices(graph)) == Enum.sort(completed ++ failed) do
      true ->
        %{state | finished: true}

      _ ->
        state
    end
  end

  defp maybe_mark_complete(state), do: state

  defp dependents_of(module, dependency_graph) do
    Graph.out_neighbors(dependency_graph, module)
  end

  defp transition_import(module, from, to, state) do
    from_list = Map.get(state, from)
    to_list = Map.get(state, to)

    state
    |> Map.put(from, List.delete(from_list, module))
    |> Map.put(to, [module | to_list])
  end
end
