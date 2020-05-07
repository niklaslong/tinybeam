defmodule Tinybeam.Server.Response do
  alias __MODULE__

  @enforce_keys [:req_ref, :body]
  defstruct [:req_ref, :body]

  def new(req_ref, body), do: %Response{req_ref: req_ref, body: body}
end