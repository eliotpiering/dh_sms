# defmodule DhSmsWeb.MessageController do
#   use DhSmsWeb, :controller

#   alias DhSms.Conversations
#   alias DhSms.Conversations.Message

#   def index(conn, %{"conversation_id" => conversation_id}) do
#     messages = Conversations.list_messages(conversation_id)
#     render(conn, "index.html", conversation_id: conversation_id, messages: messages)
#   end

#   def new(conn, %{"conversation_id" => conversation_id}) do
#     changeset = Conversations.change_message(%Message{conversation_id: conversation_id})
#     render(conn, "new.html", conversation_id: conversation_id, changeset: changeset)
#   end

#   def create(conn, %{"conversation_id" => conversation_id, "message" => message_params}) do
#     case Conversations.create_message(message_params) do
#       {:ok, message} ->
#         conn
#         |> put_flash(:info, "Message created successfully.")
#         |> redirect(to: Routes.conversation_message_path(conn, :show, conversation_id, message))

#       {:error, %Ecto.Changeset{} = changeset} ->
#         render(conn, "new.html", conversation_id: conversation_id, changeset: changeset)
#     end
#   end

#   def show(conn, %{"conversation_id" => conversation_id, "id" => id}) do
#     message = Conversations.get_message!(conversation_id, id)
#     render(conn, "show.html", conversation_id: conversation_id, message: message)
#   end

#   def edit(conn, %{"conversation_id" => conversation_id, "id" => id}) do
#     message = Conversations.get_message!(conversation_id, id)
#     changeset = Conversations.change_message(message)
#     render(conn, "edit.html", conversation_id: conversation_id, message: message, changeset: changeset)
#   end

#   def update(conn, %{"conversation_id" => conversation_id, "id" => id, "message" => message_params}) do
#     message = Conversations.get_message!(conversation_id, id)

#     case Conversations.update_message(message, message_params) do
#       {:ok, message} ->
#         conn
#         |> put_flash(:info, "Message updated successfully.")
#         |> redirect(to: Routes.conversation_message_path(conn, :show, conversation_id, message))

#       {:error, %Ecto.Changeset{} = changeset} ->
#         render(conn, "edit.html", conversation_id: conversation_id, message: message, changeset: changeset)
#     end
#   end

#   def delete(conn, %{"conversation_id" => conversation_id, "id" => id}) do
#     message = Conversations.get_message!(conversation_id, id)
#     {:ok, _message} = Conversations.delete_message(message)

#     conn
#     |> put_flash(:info, "Message deleted successfully.")
#     |> redirect(to: Routes.conversation_message_path(conn, :index, conversation_id))
#   end
# end
