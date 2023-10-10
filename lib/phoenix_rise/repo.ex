defmodule PhoenixRise.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_rise,
    adapter: Ecto.Adapters.Postgres
end
