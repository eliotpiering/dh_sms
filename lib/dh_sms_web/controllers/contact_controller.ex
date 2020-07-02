defmodule DhSmsWeb.ContactController do
  use DhSmsWeb, :controller

  alias DhSms.Conversations
  alias DhSms.Conversations.Contact

  def index(conn, %{"conversation_id" => conversation_id}) do
    contacts = Conversations.list_contacts(conversation_id)
    render(conn, "index.html", conversation_id: conversation_id, contacts: contacts)
  end

  def new(conn, %{"conversation_id" => conversation_id}) do
    changeset = Conversations.change_contact(%Contact{conversation_id: conversation_id})
    render(conn, "new.html", conversation_id: conversation_id, changeset: changeset)
  end

  def create(conn, %{"conversation_id" => conversation_id, "contact" => contact_params}) do
    case Conversations.create_contact(contact_params) do
      {:ok, contact} ->
        conn
        |> put_flash(:info, "Contact created successfully.")
        |> redirect(to: Routes.conversation_contact_path(conn, :show, conversation_id, contact))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", conversation_id: conversation_id, changeset: changeset)
    end
  end

  def show(conn, %{"conversation_id" => conversation_id, "id" => id}) do
    contact = Conversations.get_contact!(conversation_id, id)
    render(conn, "show.html", conversation_id: conversation_id, contact: contact)
  end

  def edit(conn, %{"conversation_id" => conversation_id, "id" => id}) do
    contact = Conversations.get_contact!(conversation_id, id)
    changeset = Conversations.change_contact(contact)
    render(conn, "edit.html", conversation_id: conversation_id, contact: contact, changeset: changeset)
  end

  def update(conn, %{"conversation_id" => conversation_id, "id" => id, "contact" => contact_params}) do
    contact = Conversations.get_contact!(conversation_id, id)

    case Conversations.update_contact(contact, contact_params) do
      {:ok, contact} ->
        conn
        |> put_flash(:info, "Contact updated successfully.")
        |> redirect(to: Routes.conversation_contact_path(conn, :show, conversation_id, contact))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", conversation_id: conversation_id, contact: contact, changeset: changeset)
    end
  end

  def delete(conn, %{"conversation_id" => conversation_id, "id" => id}) do
    contact = Conversations.get_contact!(conversation_id, id)
    {:ok, _contact} = Conversations.delete_contact(contact)

    conn
    |> put_flash(:info, "Contact deleted successfully.")
    |> redirect(to: Routes.conversation_contact_path(conn, :index, conversation_id))
  end
end
