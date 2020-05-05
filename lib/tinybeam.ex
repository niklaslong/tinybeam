defmodule Tinybeam do
  def start(opts), do: Tinybeam.Native.start(opts)
  def start_request_listener(server_ref), do: Tinybeam.Native.start_request_listener(server_ref)

  def handle_request(request_ref, response),
    do: Tinybeam.Native.handle_request(request_ref, response)
end
