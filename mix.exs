defmodule Tinybeam.MixProject do
  use Mix.Project

  def project do
    [
      app: :tinybeam,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Tinybeam.Application, []},
      registered: [Tinybeam.Server]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler, github: "rusterlium/rustler", sparse: "rustler_mix", branch: "master"},
      {:mint, "~> 1.0", only: [:test, :dev]}
    ]
  end

  defp aliases do
    [
      fmt: ["format", "cmd cargo fmt --manifest-path native/tinybeam/Cargo.toml"]
    ]
  end
end
