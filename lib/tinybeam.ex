defmodule Tinybeam do
  def start(), do: Tinybeam.Native.start()
  def request_listener(state), do: Tinybeam.Native.request_listener(state)
  def handle_request(server_ref, request_ref), do: Tinybeam.Native.handle_request(server_ref, request_ref)
end
