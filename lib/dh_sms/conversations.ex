defmodule DhSms.Conversations do
  import Ecto.Query, warn: false
  alias DhSms.Repo

  alias DhSms.Conversations.{Conversation, Contact, Message}

  def list_conversations do
    Repo.all(Conversation)
  end

  def list_with_contacts_and_messages() do
    Repo.all from c in Conversation, preload: [:contact, :messages]
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

  def list_contacts(conversation_id) do
    Repo.all(from c in Contact, where: c.conversation_id == ^conversation_id)
  end

  def get_contact!(conversation_id, id) do
    Repo.get_by!(Contact, [id: id, conversation_id: conversation_id])
  end

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

  def list_messages(conversation_id) do
    Repo.all(from m in Message, where: m.conversation_id == ^conversation_id)
  end

  def get_message!(conversation_id, id) do
    Repo.get_by!(Message, [id: id, conversation_id: conversation_id])
  end

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
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
