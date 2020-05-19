defmodule Tinybeam.Server.Response do
  alias __MODULE__

  @enforce_keys [:req_ref, :status_code, :headers, :body]
  defstruct [:req_ref, :status_code, :headers, :body]

  def new(req_ref, status_code, body, headers),
    do: %Response{req_ref: req_ref, status_code: status_code, body: body, headers: headers}
end
