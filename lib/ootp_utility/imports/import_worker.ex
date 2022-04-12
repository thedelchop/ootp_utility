defmodule OOTPUtility.Imports.ImportWorker do
  use GenServer

  alias OOTPUtility.Imports.{ImportSession, ImportState}

  def start_link([session, path]) do
    GenServer.start_link(__MODULE__, {session, path})
  end

  def import_module(worker, module) do
    GenServer.cast(worker, {:import_module, module, worker})
  end

  def init({session, path}) do
    {:ok, {session, path}}
  end

  def handle_cast({:import_module, module, worker}, {session, path} = state) do
    module.import_from_path(path)

    ImportState.import_completed(session, module)

    ImportSession.checkin_worker(session, worker)

    {:noreply, state}
  end
end
