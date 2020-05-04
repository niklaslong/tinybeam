defmodule Tinybeam.Server do
  use GenServer
  require IEx

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  # def init(opts) do
  #   ref = Tinybeam.Native.start()
  #   {:ok, %{server_ref: ref}}
  # end

  # def handle_info(_, state) do
  #   Task.start(fn -> Tiny.Server.handle_request(request) end)
  # end

  # def handle_req(state) do
  #   IEx.pry
  # end
end
