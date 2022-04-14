defmodule OOTPUtility.Imports.ImportSession do
  use GenServer

  alias OOTPUtility.Imports
  alias OOTPUtility.Imports.{ImportState, ImportSupervisor, ImportWorker}

  def start_link(path) do
    GenServer.start_link(__MODULE__, path, name: __MODULE__)
  end

  def init(path) do
    ImportSupervisor.start_link({self(), build_dependency_graph(), path})

    ImportState.import_available(self(), Imports.Leagues.League)

    {:ok, path}
  end

  def process_available_imports(session) do
    if ImportState.finished?(session) do
      IO.puts("Import appears to be finished, shutting down.")
      GenServer.stop(__MODULE__)
    else
      GenServer.call(__MODULE__, :process_available_imports, :infinity)

      process_available_imports(session)
    end
  end

  def checkin_worker(session, worker) do
    GenServer.call(session, {:checkin_worker, worker})
  end

  def handle_call(:process_available_imports, _from, state) do
    case :poolboy.status(:import_worker) do
      {:ready, num_workers, _, _} ->
        assign_work(self(), num_workers)

        :ok

      _ ->
        :ok
    end

    {:reply, :ok, state}
  end

  def handle_call({:checkin_worker, worker}, _from, state) do
    :poolboy.checkin(:import_worker, worker)

    {:reply, :ok, state}
  end

  defp assign_work(session, num_workers) do
    session
    |> ImportState.available_for_import()
    |> Enum.take(num_workers)
    |> Enum.each(&import_module(session, &1))
  end

  defp import_module(session, module) do
    ImportState.import_started(session, module)

    worker = :poolboy.checkout(:import_worker)

    ImportWorker.import_module(worker, module)
  end

  defp build_dependency_graph() do
    Graph.new()
    |> Graph.add_vertex(Imports.Leagues.League)
    |> Graph.add_edge(Imports.Leagues.League, Imports.Leagues.Conference)
    |> Graph.add_edge(Imports.Leagues.Conference, Imports.Leagues.Division)
    |> Graph.add_edge(Imports.Leagues.Division, Imports.Teams.Team)
    |> Graph.add_edge(Imports.Teams.Team, Imports.Teams.Affiliation)
    |> Graph.add_edge(Imports.Teams.Team, Imports.Standings.TeamRecord)
    |> Graph.add_edge(Imports.Teams.Team, Imports.Statistics.Batting.Team)
    |> Graph.add_edge(Imports.Teams.Team, Imports.Statistics.Pitching.Team.Combined)
    |> Graph.add_edge(Imports.Teams.Team, Imports.Statistics.Pitching.Team.Starters)
    |> Graph.add_edge(Imports.Teams.Team, Imports.Statistics.Pitching.Team.Bullpen)
    |> Graph.add_edge(Imports.Teams.Team, Imports.Statistics.Fielding.Team)
    |> Graph.add_edge(Imports.Teams.Team, Imports.Players.Player)
    |> Graph.add_edge(Imports.Players.Player, Imports.Teams.Roster.Membership)
    |> Graph.add_edge(Imports.Players.Player, Imports.Statistics.Batting.Player)
    |> Graph.add_edge(Imports.Players.Player, Imports.Statistics.Pitching.Player)
    |> Graph.add_edge(Imports.Players.Player, Imports.Statistics.Fielding.Player)
    |> Graph.add_edge(Imports.Players.Player, Imports.Players.Attributes.Batting)
    |> Graph.add_edge(Imports.Players.Player, Imports.Players.Attributes.Pitching)
    |> Graph.add_edge(Imports.Players.Player, Imports.Players.Attributes.Pitches)
    |> Graph.add_edge(Imports.Players.Player, Imports.Players.Attributes.Fielding)
    |> Graph.add_edge(Imports.Players.Player, Imports.Players.Attributes.Position)
    |> Graph.add_edge(Imports.Players.Player, Imports.Players.Attributes.Running)
    |> Graph.add_edge(Imports.Players.Player, Imports.Players.Morale)
    |> Graph.add_edge(Imports.Players.Player, Imports.Players.Personality)
    |> Graph.add_edge(Imports.Players.Player, Imports.Games.Game)
    |> Graph.add_edge(Imports.Players.Player, Imports.Players.Attributes.Misc.Batting)
    |> Graph.add_edge(Imports.Players.Player, Imports.Players.Attributes.Misc.Pitching)
    |> Graph.add_edge(Imports.Players.Player, Imports.Players.Attributes)
    |> Graph.add_edge(Imports.Games.Game, Imports.Statistics.Batting.Game)
    |> Graph.add_edge(Imports.Games.Game, Imports.Statistics.Pitching.Game)
    |> Graph.add_edge(Imports.Games.Game, Imports.Games.Score)
  end
end
