defmodule Bowman.Repo do
  use Ecto.Repo,
    otp_app: :bowman,
    adapter: Ecto.Adapters.Postgres
end
