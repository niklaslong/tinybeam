defmodule Tinybeam.Server.Response do
  alias __MODULE__

  @enforce_keys [:req_ref, :headers, :body]
  defstruct [:req_ref, :headers, :body]

  def new(req_ref, body, headers), do: %Response{req_ref: req_ref, body: body, headers: headers}
end
