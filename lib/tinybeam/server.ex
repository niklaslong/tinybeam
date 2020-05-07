defmodule Tinybeam.Server do
  use GenServer

  alias Tinybeam.Server.{Config, Request, Response}

  require IEx
  require Logger

  def start_link(_opts) do
    config = Config.new()
    GenServer.start_link(__MODULE__, config, name: __MODULE__)
  end

  def init(config) do
    :ok = Tinybeam.Native.start(config)
    {:ok, "started"}
  end

  def handle_info({:request, %Request{} = request}, state) do
    Task.Supervisor.start_child(Tinybeam.TaskSupervisor, fn ->
      Tinybeam.Server.handle_request(request)
    end)

    {:noreply, state}
  end

  def handle_request(request) do
    :ok =
      request.req_ref
      |> Response.new("I think it works")
      |> Tinybeam.Native.handle_request()
  end
end
