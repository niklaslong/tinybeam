defmodule Tinybeam.Native do
  use Rustler, otp_app: :tinybeam, crate: "tinybeam"

  def start(_config), do: error()
  def handle_request(_request_ref, _response), do: error()

  defp error(), do: :erlang.nif_error(:tinybeam_not_loaded)
end
