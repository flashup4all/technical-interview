defmodule BambooInterview.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BambooInterviewWeb.Telemetry,
      # Start the Ecto repository
      BambooInterview.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: BambooInterview.PubSub},
      # Start Finch
      {Finch, name: BambooInterview.Finch},
      # Start the Endpoint (http/https)
      BambooInterviewWeb.Endpoint,
      # Start a worker by calling: BambooInterview.Worker.start_link(arg)
      # {BambooInterview.Worker, arg}
      # Start a worker by calling: BambooInterview.Events.CreateStocksCronJob.start_link()
      # {Bamboo.Worker, arg}
      BambooInterview.Events.CreateStocksCronJob
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BambooInterview.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BambooInterviewWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
