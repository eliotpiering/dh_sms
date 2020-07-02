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

{:ok, campaign} =
  %{name: Faker.Company.En.bs(), send_delay: 1, intro_message: Faker.Lorem.Shakespeare.hamlet()}
  |> Messaging.create_campaign()

Enum.each(1..5, fn i ->
  dummy_email = "#{Faker.Name.first_name() <> Faker.Name.first_name() <> Faker.Name.first_name()}@example.com"

  {:ok, contact} =
    %{name: Faker.Name.name(), email: dummy_email, phone: "***********"}
    |> Messaging.create_contact()

    {:ok, conversation} = Messaging.create_conversation(%{contact_id: contact.id, campaign_id: campaign.id})

    msg_count = :rand.uniform(10)

    Enum.each(0..msg_count, fn j ->
      from_dh = rem(j, 2) == 1
      Messaging.create_message(%{body: Faker.Cat.En.breed(), conversation_id: conversation.id, from_dh: from_dh})
    end)
end)

IO.puts("Seeding complete!")
