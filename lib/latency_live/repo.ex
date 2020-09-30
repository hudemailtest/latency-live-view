defmodule LatencyLive.Repo do
  use Ecto.Repo,
    otp_app: :latency_live,
    adapter: Ecto.Adapters.Postgres
end
