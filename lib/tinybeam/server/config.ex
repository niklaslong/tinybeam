defmodule Tinybeam.Server.Config do
  @enforce_keys [:host]
  defstruct [:host]

  def new(), do: %__MODULE__{host: host()}

  defp host(), do: Application.get_env(:tinybeam, :host_rs)
end
