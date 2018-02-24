defmodule Lightbulb.Mixfile do
  use Mix.Project

  def project do
    [
      app: :lightbulb,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      test_coverage:     [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Lightbulb, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:excoveralls, "~> 0.7",   only: :test}
    ]
  end
end
