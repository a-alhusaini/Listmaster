defmodule Listmaster.Repo do
  use Ecto.Repo,
    otp_app: :listmaster,
    adapter: Ecto.Adapters.Postgres
end
