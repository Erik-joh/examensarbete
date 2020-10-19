defmodule Xarb.Repo do
  use Ecto.Repo,
    otp_app: :xarb,
    adapter: Ecto.Adapters.Postgres
end
