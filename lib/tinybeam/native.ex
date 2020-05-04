defmodule Tinybeam.Native do
  use Rustler, otp_app: :tinybeam, crate: "tinybeam"

  def start(), do: error()

  defp error(), do: :erlang.nif_error(:tinybeam_not_loaded)
end
