defmodule JumpStart.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: GoogleApiMockServer.Base, options: [port: 8080]},
      {Plug.Cowboy, scheme: :http, plug: OpenaiApiMockServer.Base, options: [port: 8081]},
      JumpStartWeb.Telemetry,
      JumpStart.Repo,
      {DNSCluster, query: Application.get_env(:jump_start, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: JumpStart.PubSub},
      # Start a worker by calling: JumpStart.Worker.start_link(arg)
      # {JumpStart.Worker, arg},
      # Start to serve requests, typically the last entry
      JumpStartWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: JumpStart.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JumpStartWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
