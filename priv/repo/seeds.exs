# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DhSms.Repo.insert!(%DhSms.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias DhSms.Conversations


{:ok, convo} = Conversations.create_conversation(%{})
IO.inspect(convo)
{:ok, contact} = Conversations.create_contact(%{name: FakerElixir.Name.name(), email: FakerElixir.Name.name(), phone: "***********", conversation_id: convo.id})

1..10
  |> Enum.each(fn i ->
  msg_count = :rand.uniform(10)
  (0..msg_count) |> Enum.each(fn j ->
    IO.inspect(i, label: "I")
    IO.inspect(j, label: "k")
    from_dh = rem(j, 2) == 1
    Conversations.create_message(%{body: FakerElixir.Lorem.sentences(2), conversation_id: convo.id, from_dh: from_dh})
  end)
end)
