defmodule ExNdjson.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_ndjson,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
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
      {:espec, "~> 1.6.1", only: :test},
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      files: ~w(lib mix.exs README.md LICENSE VERSION),
      maintainers: ["Faissal Elamraoui"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/amrfaissal/ex_ndjson"}
    ]
  end
end
