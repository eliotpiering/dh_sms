defmodule DhSmsWeb.MessageController do
  use DhSmsWeb, :controller

  alias DhSms.Messaging
  alias DhSms.Messaging.Message

  def index(conn, %{"contact_id" => contact_id}) do
    messages = Messaging.list_messages(contact_id)
    render(conn, "index.html", contact_id: contact_id, messages: messages)
  end

  def new(conn, %{"contact_id" => contact_id}) do
    changeset = Messaging.change_message(%Message{contact_id: contact_id})
    render(conn, "new.html", contact_id: contact_id, changeset: changeset)
  end

  def create(conn, %{"contact_id" => contact_id, "message" => message_params}) do
    case Messaging.create_message(message_params) do
      {:ok, message} ->
        conn
        |> put_flash(:info, "Message created successfully.")
        |> redirect(to: Routes.contact_message_path(conn, :show, contact_id, message))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"contact_id" => contact_id, "id" => id}) do
    message = Messaging.get_message!(contact_id, id)
    render(conn, "show.html", contact_id: contact_id, message: message)
  end

  def edit(conn, %{"contact_id" => contact_id, "id" => id}) do
    message = Messaging.get_message!(contact_id, id)
    changeset = Messaging.change_message(message)
    render(conn, "edit.html", contact_id: contact_id, message: message, changeset: changeset)
  end

  def update(conn, %{"contact_id" => contact_id, "id" => id, "message" => message_params}) do
    message = Messaging.get_message!(contact_id, id)

    case Messaging.update_message(message, message_params) do
      {:ok, message} ->
        conn
        |> put_flash(:info, "Message updated successfully.")
        |> redirect(to: Routes.contact_message_path(conn, :show, contact_id, message))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", contact_id: contact_id, message: message, changeset: changeset)
    end
  end

  def delete(conn, %{"contact_id" => contact_id, "id" => id}) do
    message = Messaging.get_message!(contact_id, id)
    {:ok, _message} = Messaging.delete_message(message)

    conn
    |> put_flash(:info, "Message deleted successfully.")
    |> redirect(to: Routes.contact_message_path(conn, :index, contact_id))
  end
end
