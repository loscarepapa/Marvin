defmodule Marvin.MixProject do
  use Mix.Project

  def project do
    [
      app: :marvin,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :hound]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:hound, "~> 1.0"},
      {:floki, "~> 0.29.0"},
      {:exoffice, "~> 0.3.2"},
      {:printex, "~> 1.1.0"},
      {:httpoison, "~> 1.6"},
      {:crawly, "~> 0.12.0"},
    ]
  end
end
