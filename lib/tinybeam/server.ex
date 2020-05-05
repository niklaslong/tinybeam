defmodule Tinybeam.Server do
  use GenServer
  require IEx

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    :ok = Tinybeam.Native.start(opts)
    {:ok, "started"}
  end

  def handle_info({:hi, message}, state) do
    Task.Supervisor.start_child(Tinybeam.TaskSupervisor, fn ->
      Tinybeam.Server.handle_req(message)
    end)

    {:noreply, state}
  end

  def handle_req(req_ref) do
    :ok = Tinybeam.Native.handle_request(req_ref, "I think it works")
  end
end
