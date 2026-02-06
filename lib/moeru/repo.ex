defmodule Moeru.Repo do
  use Ecto.Repo,
    otp_app: :moeru,
    adapter: Ecto.Adapters.Postgres
end
