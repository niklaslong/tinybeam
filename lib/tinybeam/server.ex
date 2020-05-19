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
    response = router().match(request.method, request.path, request)

    :ok = Tinybeam.Native.handle_request(response)
  end

  # TODO: improve configuration 
  defp router(), do: Application.get_env(:tinybeam, :router)
end
