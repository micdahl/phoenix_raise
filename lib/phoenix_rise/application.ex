defmodule PhoenixRise.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PhoenixRiseWeb.Telemetry,
      # Start the Ecto repository
      PhoenixRise.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: PhoenixRise.PubSub},
      # Start Finch
      {Finch, name: PhoenixRise.Finch},
      # Start the Endpoint (http/https)
      PhoenixRiseWeb.Endpoint
      # Start a worker by calling: PhoenixRise.Worker.start_link(arg)
      # {PhoenixRise.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixRise.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixRiseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
