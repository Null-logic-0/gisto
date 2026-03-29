defmodule Gisto.Repo do
  use Ecto.Repo,
    otp_app: :gisto,
    adapter: Ecto.Adapters.Postgres
end
