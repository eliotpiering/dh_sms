defmodule DhSms.Repo do
  use Ecto.Repo,
    otp_app: :dh_sms,
    adapter: Ecto.Adapters.Postgres
end
