defmodule ExNdjson.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_ndjson,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ExNdjson.Application, []}
    ]
  end

  defp deps do
    [
      {:poison, "~> 3.1"},
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false}
    ]
  end
end
