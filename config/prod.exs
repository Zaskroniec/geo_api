import Config

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: GEOExcercise.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :geo_excercise, GEOExcercise.Repo,
  # ssl: true,
  url: database_url,
  pool_size: 2,
  socket_options: []

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
