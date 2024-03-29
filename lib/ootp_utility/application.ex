defmodule OOTPUtility.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies) || []

    children = [
      # Start the Ecto repository
      OOTPUtility.Repo,
      # Start the Telemetry supervisor
      OOTPUtilityWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: OOTPUtility.PubSub},
      # Start the Endpoint (http/https)
      OOTPUtilityWeb.Endpoint,
      # Start a TaskSupervisor to track our import tasks
      {Task.Supervisor, name: OOTPUtility.ImportTaskSupervisor},
      # Setup a Cluster supervisor to allow communication between nodes on Fly.io
      {Cluster.Supervisor, [topologies, [name: OOTPUtility.ClusterSupervisor]]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OOTPUtility.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OOTPUtilityWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
