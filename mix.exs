defmodule MadaReader.MixProject do
  use Mix.Project

  @description """
    A Gigabit Iwaki Board decoder
  """

  def project do
    [
      app: :mada_reader,
      name: "mada Reader",
      description: @description,
      package: package(),
      escript: escript_config(),
      version: "0.0.1",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      maintainers: ["hmdyt"],
      licenses: ["MIT"],
      links: %{ "Github" => "https://github.com/hmdyt/mada_reader" }
    ]
  end
  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:optimus, "~> 0.3"},
      {:json, "~> 1.4"},
      {:erlport, "~> 0.1"},
      {:progress_bar, "~> 2.0"},
      {:recon, "~> 2.5.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
    ]
  end

  defp escript_config do
    [
      main_module: MadaReader
    ]
  end
end
