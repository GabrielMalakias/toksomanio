defmodule Toksomanio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Toksomanio.Router,
        options: [port: 4002]
      )
    ]

    opts = [strategy: :one_for_one, name: Toksomanio.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
