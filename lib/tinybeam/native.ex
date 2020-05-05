defmodule Tinybeam.Native do
  use Rustler, otp_app: :tinybeam, crate: "tinybeam"

  def start(_opts), do: error()
  def start_request_listener(_server_ref), do: error()
  def handle_request(_request_ref, _response), do: error()

  defp error(), do: :erlang.nif_error(:tinybeam_not_loaded)
end
