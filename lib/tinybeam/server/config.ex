defmodule Tinybeam.Server.Config do
  defstruct [:host]

  def new(), do: %__MODULE__{host: host()}

  defp host(), do: Application.get_env(:tinybeam, :host_rs)
end
