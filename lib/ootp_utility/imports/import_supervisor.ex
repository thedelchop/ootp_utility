defmodule OOTPUtility.Imports.ImportSupervisor do
  use Supervisor

  alias OOTPUtility.Imports
  alias OOTPUtility.Imports

  def start_link({_session, _dependencies, _path} = state) do
    Supervisor.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl Supervisor
  def init({session, dependencies, path}) do
    children = [
      {Registry, keys: :unique, name: Imports.StateRegistry},
      {Imports.ImportAgent, []},
      :poolboy.child_spec(
        :import_worker,
        [
          name: {:local, :import_worker},
          worker_module: Imports.ImportWorker,
          size: 10,
          max_overflow: 0
        ],
        [
          session,
          path
        ]
      ),
      {Imports.ImportState, {session, dependencies}}
    ]

    opts = [
      strategy: :one_for_one,
      max_restarts: 5,
      max_seconds: 5
    ]

    Supervisor.init(children, opts)
  end
end
