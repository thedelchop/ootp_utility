defmodule OOTPUtility.Imports.ImportSupervisor do
  use DynamicSupervisor

  alias OOTPUtility.Imports.{ImportAgent, ImportState, ImportWorker}

  def start_link({session, dependencies, path}) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)

    # The worker pool needs no further configuration to run
    supervise_worker_pool(session, path)

    supervise_state_registry()

    supervise_import_agent()

    # The state server needs the initial steps
    supervise_state_server(session, dependencies)
  end

  @impl DynamicSupervisor
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp supervise_state_registry() do
    DynamicSupervisor.start_child(
      __MODULE__,
      {Registry, keys: :unique, name: OOTPUtility.Imports.StateRegistry}
    )
  end

  defp supervise_import_agent() do
    DynamicSupervisor.start_child(
      __MODULE__,
      {ImportAgent, []}
    )
  end

  defp supervise_worker_pool(session, path) do
    DynamicSupervisor.start_child(
      __MODULE__,
      :poolboy.child_spec(
        :import_worker,
        [
          name: {:local, :import_worker},
          worker_module: ImportWorker,
          size: 10,
          max_overflow: 0
        ],
        [
          session,
          path
        ]
      )
    )
  end

  defp supervise_state_server(session, dependencies) do
    DynamicSupervisor.start_child(__MODULE__, %{
      id: ImportState,
      start: {ImportState, :start_link, [session, dependencies]}
    })
  end
end
