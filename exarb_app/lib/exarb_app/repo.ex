defmodule ExarbApp.Repo do
  use Ecto.Repo,
    otp_app: :exarb_app,
    adapter: Ecto.Adapters.Postgres
end
