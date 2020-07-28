defmodule Tinybeam.Server.Config do
  @enforce_keys [:host, :pool_size]
  defstruct [:host, :pool_size]

  def new(), do: %__MODULE__{host: host(), pool_size: pool_size()}

  defp host(), do: Application.get_env(:tinybeam, :host_rs)
  defp pool_size(), do: Application.get_env(:tinybeam, :pool_size)
end
