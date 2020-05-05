defmodule Tinybeam.Server do
  use GenServer
  require IEx

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    server_ref = Tinybeam.Native.start(opts)
    Tinybeam.Server.start_listener(server_ref)
    {:ok, "started"}
  end

  def handle_info({:hi, message}, state) do
    IEx.pry
  end

  def start_listener(server_ref) do
    Task.Supervisor.start_child(Tinybeam.TaskSupervisor, fn ->
      Tinybeam.Server.handle_req(server_ref)
    end)
  end

  def handle_req(server_ref) do
    req_ref = Tinybeam.Native.start_request_listener(server_ref)

    Task.Supervisor.start_child(Tinybeam.TaskSupervisor, fn ->
      Tinybeam.Native.handle_request(req_ref, "I think it works")
    end)

    Tinybeam.Server.start_listener(server_ref)
  end
end
