defmodule DhSmsWeb.ConversationPresenter do
  alias __MODULE__
  alias DhSms.Conversations

  defstruct messages: [],
            contact_id: 0,
            last_sent_datetime: nil,
            contact_name: nil,
            unread_count: 0,
            id: nil

  def ordered_from_conversation_list(conversations) do
    conversations
    |> Enum.reduce(Keyword.new(), fn conversation, conversation_list ->
      # TODO not a long term solution
      key = conversation_key(conversation.id)

      Keyword.put(conversation_list, key, from_conversation(conversation))
    end)
    |> Enum.sort(fn {_, c1}, {_, c2} -> sort_order(c1, c2) end)
  end

  def sort_order(c1, c2) do
    cond do
      c1.unread_count == c2.unread_count ->
        DateTime.compare(c1.last_sent_datetime, c2.last_sent_datetime) == :gt

      true ->
        c1.unread_count > c2.unread_count
    end
  end

  def hash_from_conversation_list(conversations) do
    conversations
    |> Enum.reduce(%{}, fn conversation, conversation_hash ->
      key = conversation.id |> to_string

      Map.put(conversation_hash, key, from_conversation(conversation))
    end)
  end

  def from_conversation(conversation) do
    messages = Enum.map(conversation.messages, &frontend_message_from_message(&1))

    %ConversationPresenter{
      messages: messages,
      contact_id: conversation.contact.id,
      last_sent_datetime: last_sent_datetime(conversation),
      contact_name: conversation.contact.name,
      unread_count: unread_count(conversation),
      id: conversation.id
    }
  end

  def frontend_message_from_message(message) do
    %{
      body: message.body,
      sent_at: DateTime.from_naive!(message.inserted_at, "Etc/UTC"),
      from_dh: message.from_dh
      # conversation_id: conversation.id
    }
  end

  def get_by(conversations, conversation_id) do
    Keyword.get(conversations, conversation_key(conversation_id))
  end

  def conversation_key(id) do
    # TODO not a long term solution
    id |> to_string |> String.to_atom()
  end

  def last_sent_datetime(%{messages: messages}) do
    (messages |> List.first()).inserted_at |> DateTime.from_naive!("Etc/UTC")
  end

  def last_sent_datetime(date) do
    DateTime.from_naive!(date, "Etc/UTC")
  end

  def unread_count(%{messages: messages}), do: unread_count(messages)

  def unread_count(messages) do
    messages |> Enum.find_index(& &1.from_dh) || 0
  end

  def add_message_to_conversations(conversations, message) do
    old_con = get_by(conversations, message.conversation_id)
    new_messages = [frontend_message_from_message(message) | old_con.messages]

    updated = %{
      old_con
      | messages: new_messages,
        unread_count: unread_count(new_messages),
        last_sent_datetime: last_sent_datetime(message.inserted_at)
    }

    Keyword.put(conversations, conversation_key(message.conversation_id), updated)
    |> Enum.sort(fn {_, c1}, {_, c2} -> sort_order(c1, c2) end)
  end
end
