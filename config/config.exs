import Config

config :tinybeam,
  router: Tinybeam.Router,
  pool_size: 10

import_config "#{Mix.env()}.exs"
