defmodule Lighthouse.Mixfile do
  use Mix.Project

  def project do
    [
      app: :lighthouse,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Lighthouse, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:excoveralls, "~> 0.7",   only: :test}
    ]
  end
end
