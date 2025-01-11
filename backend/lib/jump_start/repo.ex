defmodule JumpStart.Repo do
  use Ecto.Repo,
    otp_app: :jump_start,
    adapter: Ecto.Adapters.Postgres
end
