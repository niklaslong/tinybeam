import Config

config :tinybeam,
  router: Tinybeam.Router

import_config "#{Mix.env()}.exs"
