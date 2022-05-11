defmodule GhostGroup.Repo do
  use Ecto.Repo,
    otp_app: :ghost_group,
    adapter: Ecto.Adapters.Postgres
end
