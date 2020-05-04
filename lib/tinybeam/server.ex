defmodule Tinybeam.Server do
  use GenServer
  require IEx

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    server_ref = Tinybeam.Native.start()
    Tinybeam.Server.start_listener(server_ref)
    {:ok, "started"}
  end

  def start_listener(server_ref) do
    Task.start(fn -> Tinybeam.Server.handle_req(server_ref) end)
  end

  def handle_req(server_ref) do
    server_ref
    |> Tinybeam.Native.start_request_listener()
    |> Tinybeam.Native.handle_request("hi mum I think this works")
    
    Tinybeam.Server.start_listener(server_ref)
  end
end
