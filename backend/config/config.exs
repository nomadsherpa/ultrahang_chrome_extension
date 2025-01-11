import Config

config :jump_start, env: Mix.env()

import_config "#{Mix.env()}.exs"
