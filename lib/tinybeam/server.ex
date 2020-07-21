defmodule Tinybeam.Server do
  use GenServer

  alias Tinybeam.{Native, TaskSupervisor}
  alias Tinybeam.Server.{Config, Request, Response}

  def start_link(_opts) do
    config = Config.new()
    GenServer.start_link(__MODULE__, config, name: __MODULE__)
  end

  def init(%Config{} = config) do
    :ok = Native.start(config)
    {:ok, "started"}
  end

  def handle_info({:request, %Request{} = request}, state) do
    Task.Supervisor.start_child(TaskSupervisor, fn ->
      __MODULE__.handle_request(request)
    end)

    {:noreply, state}
  end

  def handle_request(%Request{} = request) do
    response = %Response{} = router().match(request.method, request.path, request)
    :ok = Native.handle_request(response)
  end

  # TODO: improve configuration 
  defp router(), do: Application.get_env(:tinybeam, :router)
end
