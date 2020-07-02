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
alias DhSms.Messaging

{:ok, campaign} = Messaging.create_campaign(%{name: "First Campaign", intro_message: "Hey from dispatch", send_delay: 4 })
{:ok, contact} = Messaging.create_contact(%{campaign_id: campaign.id, name: FakerElixir.Name.name(), email: FakerElixir.Name.name(), phone: "***********"})
{:ok, convo} = Messaging.create_conversation(%{contact_id: contact.id, campaign_id: campaign.id})

msg_count = :rand.uniform(10)
(0..msg_count) |> Enum.each(fn j ->
  from_dh = rem(j, 2) == 1
  Messaging.create_message(%{body: FakerElixir.Lorem.sentences(2), conversation_id: convo.id, from_dh: from_dh})
end)
