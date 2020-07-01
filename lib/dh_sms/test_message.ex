defmodule DhSms.TestMessage do
  # a quick module to stub out message data for live view
  alias __MODULE__
  defstruct contact_id: 0, name: "Eliot", body: "", from_dh: false, sent_at: nil

  def fetch_all() do
    build_messages(10)
  end

  def build_messages(count) do
    1..count
    |> Enum.map(fn i ->
      %TestMessage{
        name: random_name(),
        body: random_body(),
        contact_id: i,
        from_dh: false,
        sent_at: random_time()
      }
    end)
  end

  defp random_name do
    FakerElixir.Name.name()
  end

  defp random_body do
    FakerElixir.Lorem.sentences(2)
  end

  defp random_time do
    offset = :rand.uniform(10_000)
    DateTime.add(DateTime.utc_now(), -offset)
  end
end
