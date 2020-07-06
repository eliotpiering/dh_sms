defmodule DhSms.Messaging do
  import Ecto.Query, warn: false
  alias DhSms.Repo

  alias DhSms.Messaging.{
    Campaign,
    Conversation,
    Contact,
    Message
  }

  def list_conversations_with_contacts_and_messages() do
    Repo.all(
      from c in Conversation,
        preload: [
          :contact,
          messages:
            ^from(
              m in Message,
              order_by: [desc: m.inserted_at]
            )
        ]
    )
  end

  def list_campaigns do
    Repo.all(Campaign)
  end

  def get_campaign!(id), do: Repo.get!(Campaign, id)

  def get_conversation!(id), do: Repo.get!(Conversation, id)

  def create_campaign(attrs \\ %{}) do
    %Campaign{}
    |> Campaign.changeset(attrs)
    |> Repo.insert()
  end

  def update_campaign(%Campaign{} = campaign, attrs) do
    campaign
    |> Campaign.changeset(attrs)
    |> Repo.update()
  end

  def delete_campaign(%Campaign{} = campaign) do
    Repo.delete(campaign)
  end

  def change_campaign(%Campaign{} = campaign, attrs \\ %{}) do
    Campaign.changeset(campaign, attrs)
  end

  def list_contacts() do
    Repo.all(Contact)
  end

  def get_contact!(id), do: Repo.get!(Contact, id)

  def create_contact(attrs \\ %{}) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Repo.insert()
  end

  def create_contacts(contacts \\ []) do
    contacts
    |> Enum.reduce(%{success: [], fail: []}, fn attrs, acc ->
      case create_contact(attrs) do
        {:ok, contact} ->
          %{acc | success: [contact | acc.success]}

        {:error, %Ecto.Changeset{} = changeset} ->
          %{acc | fail: [changeset | acc.fail]}
      end
    end)
  end

  def update_contact(%Contact{} = contact, attrs) do
    contact
    |> Contact.changeset(attrs)
    |> Repo.update()
  end

  def delete_contact(%Contact{} = contact) do
    Repo.delete(contact)
  end

  def change_contact(%Contact{} = contact, attrs \\ %{}) do
    Contact.changeset(contact, attrs)
  end

  def list_conversations do
    Repo.all(Conversation)
  end

  def get_conversation!(id), do: Repo.get!(Conversation, id)

  def create_conversation(attrs \\ %{}) do
    %Conversation{}
    |> Conversation.changeset(attrs)
    |> Repo.insert()
  end

  def update_conversation(%Conversation{} = conversation, attrs) do
    conversation
    |> Conversation.changeset(attrs)
    |> Repo.update()
  end

  def delete_conversation(%Conversation{} = conversation) do
    Repo.delete(conversation)
  end

  def change_conversation(%Conversation{} = conversation, attrs \\ %{}) do
    Conversation.changeset(conversation, attrs)
  end

  def list_messages() do
    Repo.all(Message)
  end

  def get_message!(id), do: Repo.get!(Message, id)

  def create_message_from_webhook(%{"Body" => body, "To" => to, "From" => from}) do
    contact_id = Repo.get_by(Contact, phone: from).id
    campaign_id = Repo.get_by(Campaign, phone: to).id
    conversation_id = Repo.get_by(Conversation, contact_id: contact_id, campaign_id: campaign_id).id

    attrs = %{
      body: body,
      from_dh: false,
      conversation_id: conversation_id
    }

    create_message(attrs)
  end

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def create_and_send_message(contact_id, attrs \\ %{}) do
    #TODO error catching
    contact = get_contact!(contact_id)
    to = contact.phone
    {:ok, _} = DhSms.Twilio.send_message(to, attrs[:body])
    {:ok, message} = create_message(attrs)
  end

  @topic "conversation:lobby"
  @event :new_msg
  def send_msg_to_liveview(message) do
    Phoenix.PubSub.broadcast(DhSms.PubSub, @topic, {@event, message})
  end

  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
