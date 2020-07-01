defmodule DhSms.Messaging do
  import Ecto.Query, warn: false
  alias DhSms.Repo

  alias DhSms.Messaging.{Contact, Message}


  def list_contacts do
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

  def list_messages(contact_id) do
    Repo.all(from m in Message, where: m.contact_id == ^contact_id)
  end

  def get_message!(contact_id, id), do: Repo.get_by!(Message, [id: id, contact_id: contact_id])

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
