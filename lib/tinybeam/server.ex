defmodule Tinybeam.Server do
  use GenServer

  alias Tinybeam.Server.Config

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

  def handle_info({:request, message}, state) do
    Task.Supervisor.start_child(Tinybeam.TaskSupervisor, fn ->
      Tinybeam.Server.handle_req(message)
    end)

    {:noreply, state}
  end

  def handle_req(req_ref) do
    :ok = Tinybeam.Native.handle_request(req_ref, "I think it works")
  end
end
