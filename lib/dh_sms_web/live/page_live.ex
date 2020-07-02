defmodule DhSmsWeb.PageLive do
  use DhSmsWeb, :live_view

  alias DhSms.Conversation
  alias DhSms.TestMessage

  @impl true
  def mount(_params, _session, socket) do
    messages = TestMessage.fetch_all()
    all_conversations = Conversation.build_from_messages(messages)
    {:ok, assign(socket, conversations: all_conversations, current_conversation: %Conversation{})}
  end

  def message_preview(conversation) do
    message = conversation.messages |> List.first()
    truncated_body = message.body |> String.slice(0..100)
    "#{truncated_body}..."
  end

  def formatted_date(date) do
    {:ok, date} = date |> DateTime.shift_zone("America/Chicago")
    {:ok, formatted} = Calendar.Strftime.strftime(date, "%a %b %e, %l:%M %p")
    formatted
  end

  def conversation_message_class(message) do
    if message.from_dh, do: "column-offset-50 dh-message", else: "user-message"
  end

  def conversation_mini_class(conversation, current_contact_id) do
    if (conversation.contact_id == current_contact_id) do
      "active-conversation"
    end
  end

  def messages_reverse_order(conversation) do
    conversation.messages |> Enum.reverse
  end


  @impl true
  def handle_event("change_conversation", %{"contact-id" => contact_id}, socket) do
    conversation = socket.assigns.conversations |> Map.get(contact_id)
    {:noreply, assign(socket, current_conversation: conversation)}
  end


  @impl true
  def handle_event("new_message", %{"body" => body, "contact-id" => contact_id}, socket) do
    #Conversation.add_message(conversation_id, body)
    conversations = Conversation.add_message_to_conversations(socket.assigns.conversations, %TestMessage{contact_id: contact_id, name: "", body: body, from_dh: true, sent_at: DateTime.utc_now()})

    {:noreply, assign(socket, conversations: conversations, current_conversation: Map.get(conversations, contact_id))}
  end

  # @impl true
  # def handle_event("search", %{"q" => query}, socket) do
  #   case search(query) do
  #     %{^query => vsn} ->
  #       {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

  #     _ ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:error, "No dependencies found matching \"#{query}\"")
  #        |> assign(results: %{}, query: query)}
  #   end
  # end

  # defp search(query) do
  #   if not DhSmsWeb.Endpoint.config(:code_reloader) do
  #     raise "action disabled when not in development"
  #   end

  #   for {app, desc, vsn} <- Application.started_applications(),
  #       app = to_string(app),
  #       String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
  #       into: %{},
  #       do: {app, vsn}
  # end
end
