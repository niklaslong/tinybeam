defmodule Tinybeam.Native do
  use Rustler, otp_app: :tinybeam, crate: "tinybeam"

  def start(), do: error()
  def request_listener(_s), do: error()
  def handle_request(_server_ref, _request_ref), do: error()

  defp error(), do: :erlang.nif_error(:tinybeam_not_loaded)
end
