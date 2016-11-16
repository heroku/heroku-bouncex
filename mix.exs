defmodule Heroku.Mixfile do
  use Mix.Project

  def project do
    [app: :heroku_bouncex,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     dialyzer: [ plt_file: ".local.plt" ]
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :cowboy, :plug, :oauth2]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:plug, "~> 1.2.2"},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:dialyxir, "~> 0.4", only: [:dev]},
      {:oauth2, "~> 0.8"},
      {:poison, "~> 3.0"},
      {:cowboy, "~> 1.0.4"},
      {:bypass, "~> 0.1", only: [:test]}
    ]
  end
end
