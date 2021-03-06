defmodule ExNdjson.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_ndjson,
      version: "0.3.2",
      elixir: "~> 1.0",
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [
        espec: :test
      ],
      description: description(),
      package: package(),
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
      {:jason, "~> 1.1"},
      {:espec, "~> 1.6.1", only: :test},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    Implementation of Newline Delimited JSON (NDJSON) for Elixir
    """
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
