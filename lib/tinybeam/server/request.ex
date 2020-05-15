defmodule Tinybeam.Server.Request do
  @enforce_keys [:req_ref, :method, :headers, :content]
  defstruct [:req_ref, :method, :headers, :content]
end
