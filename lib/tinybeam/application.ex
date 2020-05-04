defmodule Tinybeam.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Tinybeam

  def start(_type, _args) do
    children = [
      Tinybeam.Server
    ]

    opts = [strategy: :one_for_one, name: Tinybeam.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
