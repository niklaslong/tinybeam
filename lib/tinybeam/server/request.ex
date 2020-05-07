defmodule Tinybeam.Server.Request do
  @enforce_keys [:req_ref, :method]
  defstruct [:req_ref, :method]
end
