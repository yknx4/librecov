import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# Start the phoenix server if environment is set and running in a release
if System.get_env("PHX_SERVER") && System.get_env("RELEASE_NAME") do
  config :librecov, LibrecovWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  config :librecov, Librecov.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POSTGRES_POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")
  ssl_port = String.to_integer(System.get_env("SSL_PORT") || "8443")

  if System.get_env("SSL_KEY") && System.get_env("SSL_CERT") do
    config :librecov, LibrecovWeb.Endpoint,
      https: [
        ip: {0, 0, 0, 0, 0, 0, 0, 0},
        compress: true,
        port: ssl_port,
        key: {:RSAPrivateKey, System.get_env("SSL_KEY") |> Base.decode64!()},
        cert: {:RSAPrivateKey, System.get_env("SSL_CERT") |> Base.decode64!()}
      ]
  end

  config :librecov, LibrecovWeb.Endpoint,
    url: [
      scheme: System.get_env("LIBRECOV_SCHEME") || "https",
      host: System.get_env("LIBRECOV_HOST") || "librecov.com",
      port: System.get_env("LIBRECOV_PORT") || 443
    ],
    static_url: [
      scheme: System.get_env("LIBRECOV_SCHEME") || "https",
      host: System.get_env("LIBRECOV_CDN_HOST") || "cdn.librecov.com",
      port: System.get_env("LIBRECOV_PORT") || 443
    ],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port,
      compress: true
    ],
    secret_key_base: secret_key_base,
    live_view: [signing_salt: System.get_env("LIBRECOV_LIVEVIEW_SALT")],
    check_origin: false

  config :librecov, :auth,
    enable: System.get_env("LIBRECOV_AUTH") == "true",
    username: System.get_env("LIBRECOV_USER"),
    password: System.get_env("LIBRECOV_PASSWORD"),
    realm: System.get_env("LIBRECOV_REALM") || "Protected LibreCov"

  config Librecov.Plug.Github,
    secret: System.get_env("LIBRECOV_GITHUB_WEBOOK_SECRET") || "super-secret"

  config :sentry,
    dsn: System.get_env("SENTRY_DSN"),
    environment_name: System.get_env("RELEASE_LEVEL") || "prod"

  config :event_bus_logger,
    enabled: {:system, "EB_LOGGER_ENABLED", "true"},
    level: {:system, "EB_LOGGER_LEVEL", :info},
    topics: {:system, "EB_LOGGER_TOPICS", ".*"},
    light_logging: {:system, "EB_LOGGER_LIGHT", "false"}

  config :librecov, :github,
    app_id: System.get_env("GITHUB_APP_ID"),
    client_id: System.get_env("GITHUB_CLIENT_ID"),
    client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
    app_name: System.get_env("GITHUB_APP_NAME")

  config :ueberauth, Ueberauth.Strategy.Github.OAuth,
    client_id: System.get_env("GITHUB_CLIENT_ID"),
    client_secret: System.get_env("GITHUB_CLIENT_SECRET")

  config :librecov, Librecov.Authentication, secret_key: System.get_env("LIBRECOV_LIVEVIEW_SALT")

  # ## Using releases
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  #     config :librecov, LibrecovWeb.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  #     config :librecov, Librecov.Mailer,
  #       adapter: Swoosh.Adapters.Mailgun,
  #       api_key: System.get_env("MAILGUN_API_KEY"),
  #       domain: System.get_env("MAILGUN_DOMAIN")
  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.
end
