defmodule JumpStart.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: GoogleApiMockServer.Base, options: [port: 4000]},
      {Plug.Cowboy, scheme: :http, plug: OpenaiApiMockServer.Base, options: [port: 4001]}
    ]

    opts = [strategy: :one_for_one, name: JumpStart.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
