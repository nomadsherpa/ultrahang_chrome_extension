import Config

config :ultrahang_backend, env: Mix.env()

import_config "#{Mix.env()}.exs"
