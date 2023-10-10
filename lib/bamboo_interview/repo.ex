defmodule BambooInterview.Repo do
  use Ecto.Repo,
    otp_app: :bamboo_interview,
    adapter: Ecto.Adapters.Postgres
end
