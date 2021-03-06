defmodule DhSmsWeb.PageLive do
  use DhSmsWeb, :live_view

  alias DhSms.Messaging
  alias DhSmsWeb.{ConversationPresenter, Endpoint}

  @topic "conversation:lobby"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(DhSms.PubSub, @topic)
    end

    all_conversations =
      Messaging.list_conversations_with_contacts_and_messages()
      |> ConversationPresenter.ordered_from_conversation_list()

    {:ok,
     assign(socket,
       conversations: all_conversations,
       current_conversation: %ConversationPresenter{},
       chat_message: ""
     )}
  end

  def terminate(reason, socket) do
    Phoenix.PubSub.unsubscribe(DhSms.PubSub, @topic)

    {:ok, socket}
  end

  def message_preview(conversation) do
    message = conversation.messages |> List.first()
    truncated_body = message.body |> String.slice(0..100)
    "#{truncated_body}..."
  end

  def formatted_date(date) do
    {:ok, date} = DateTime.shift_zone(date, "America/Chicago")
    {:ok, formatted} = Calendar.Strftime.strftime(date, "%a %b %e, %l:%M %p")
    formatted
  end

  def conversation_message_class(message) do
    if message.from_dh, do: "column-offset-50 dh-message", else: "user-message"
  end

  def conversation_mini_class(conversation, current_contact_id) do
    if conversation.contact_id == current_contact_id do
      "active-conversation"
    end
  end

  def messages_reverse_order(conversation) do
    conversation.messages |> Enum.reverse()
  end

  @impl true
  def handle_event("change_conversation", %{"contact-id" => contact_id}, socket) do
    conversation = socket.assigns.conversations |> ConversationPresenter.get_by(contact_id)
    {:noreply, assign(socket, current_conversation: conversation, chat_message: "")}
  end

  def handle_event("update_chat_message", %{"body" => body}, socket) do
    {:noreply, assign(socket, chat_message: body)}
  end

  @impl true
  def handle_event("new_message", %{"contact-id" => contact_id}, socket) do
    conversation = socket.assigns.current_conversation
    conversation_id = conversation.id
    contact_id = conversation.contact_id

    {:ok, message} =
      Messaging.create_and_send_message(contact_id, %{
        body: socket.assigns.chat_message,
        from_dh: true,
        conversation_id: conversation_id
      })

    conversations =
      ConversationPresenter.add_message_to_conversations(socket.assigns.conversations, message)

    current_conversation =
      ConversationPresenter.get_by(conversations, socket.assigns.current_conversation.id)

    new_assigns = %{
      chat_message: "",
      conversations: conversations,
      current_conversation: current_conversation
    }

    Endpoint.broadcast_from!(self(), @topic, "new_msg", %{message: message})

    {:noreply, assign(socket, new_assigns)}
  end

  @impl true
  def handle_info(%{event: "new_msg", payload: %{message: message} = _payload}, socket) do
    conversations =
      ConversationPresenter.add_message_to_conversations(socket.assigns.conversations, message)

    current_conversation =
      ConversationPresenter.get_by(conversations, socket.assigns.current_conversation.id)

    {:noreply,
     assign(socket,
       conversations: conversations,
       current_conversation: current_conversation || %ConversationPresenter{}
     )}
  end
end
