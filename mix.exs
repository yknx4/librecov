defmodule Librecov.Mixfile do
  use Mix.Project

  def project do
    [
      app: :librecov,
      version: "0.0.1",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers() ++ [:surface],
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env:
        cli_env_for(:test, [
          "coveralls",
          "coveralls.detail",
          "coveralls.html",
          "coveralls.json",
          "coveralls.post",
          "vcr",
          "vcr.delete",
          "vcr.check",
          "vcr.show"
        ])
    ]
  end

  defp cli_env_for(env, tasks) do
    Enum.reduce(tasks, [], fn key, acc -> Keyword.put(acc, :"#{key}", env) end)
  end

  def application do
    [mod: {Librecov, []}, extra_applications: [:logger, :crypto, :event_bus]]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  defp deps do
    [
      {:nodejs, "~> 2.0"},
      {:oauth2, "~> 2.0"},
      {:sobelow, "~> 0.11", only: :dev},
      {:event_bus_logger, "~> 0.1.6"},
      {:elixir_uuid, "~> 1.2"},
      {:event_bus,
       github: "yknx4/event_bus", ref: "49027b459afc325ebf71a1e5001fb8718b4e7d80", override: true},
      {:mutex, "~> 1.3"},
      {:deep_merge, "~> 1.0"},
      {:sentry, "~> 8.0"},
      {:plug_cloudflare, "~> 1.3"},
      {:joken, "~> 2.4"},
      {:stream_gzip, "~> 0.4"},
      {:gettext, "~> 0.19"},
      {:temp, "~> 0.4"},
      {:timex, "~> 3.7"},
      {:scrivener_ecto, "~> 2.7"},
      {:navigation_history, "~> 0.4"},
      {:ex_machina, "~> 2.7"},
      {:mailman, "~> 0.4"},
      {:eiconv, "~> 1.0"},
      {:scrivener_html, "~> 1.8"},
      {:excoveralls, "~> 0.14", only: :test},
      {:mock, "~> 0.3", only: :test},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:jason, "~> 1.0"},
      {:phoenix, "~> 1.6.0-rc.0", override: true},
      {:phoenix_html, "~> 3.0", override: true},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.7"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_view, "~> 0.17.0"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 0.5"},
      {:plug_cowboy, "~> 2.5"},
      {:ranch, "~> 2.0", override: true},
      {:meck, "~> 0.9", override: true},
      {:tesla, "~> 1.4"},
      {:poison, "~> 3.0"},
      {:ex_octocat, github: "yknx4/ex_octocat", tag: "v1.1.4.1"},
      {:open_api_spex, "~> 3.10"},
      {:ueberauth, "~> 0.7"},
      {:ueberauth_github,
       github: "ueberauth/ueberauth_github", ref: "0617af32b52b77e64f261da36b13b5c5d1616ab1"},
      {:ueberauth_identity, "~> 0.4"},
      {:guardian, "~> 2.2"},
      {:guardian_db, "~> 2.1"},
      {:guardian_phoenix, "~> 2.0"},
      {:argon2_elixir, "~> 2.0"},
      {:ecto_resource, "~> 1.3"},
      {:floki, ">= 0.30.0", only: :test},
      {:surface, "~> 0.7.0"},
      {:kaffy, "~> 0.9.0"},
      {:ecto_factory, "~> 0.3.0"},
      {:shorter_maps, "~> 2.0"},
      {:mix_test_interactive, "~> 1.0", only: :dev, runtime: false},
      {:exvcr, "~> 0.16", only: :test},
      {:ibrowse, "~> 4.2", only: :test},
      {:snapshy, "~> 0.2", only: :test},
      {:unsafe, "~> 1.0"},
      {:secure_random, "~> 0.5"},
      {:surface_formatter, "~> 0.7.0", only: :dev}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "assets.deploy": [
        "cmd --cd assets ../node_modules/.bin/ts-node build.ts",
        "phx.digest"
      ],
      sentry_recompile: ["compile", "deps.compile sentry --force"]
    ]
  end
end
