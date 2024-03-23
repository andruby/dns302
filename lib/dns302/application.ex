defmodule Dns302.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Bandit, plug: {Dns302.Server, host: Application.fetch_env!(:dns302, :host)}}
    ]

    opts = [strategy: :one_for_one, name: Dns302.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
