defmodule DhSms.Conversation do
  alias __MODULE__
  defstruct messages: [], contact_id: 0, last_read_datetime: nil, contact_name: nil

  def build_from_messages(messages) do
    messages
    |> Enum.reduce(%{}, fn message, conversation_hash ->
      add_message_to_conversations(conversation_hash, message)
    end)
  end

  def add_message_to_conversations(conversation_hash, message) do
    {_, updated_hash} = Map.get_and_update(conversation_hash, message.contact_id, fn existing_con ->
      updated_con =
        case existing_con do
          nil ->
            %Conversation{
              messages: [message],
              contact_id: message.contact_id,
              contact_name: message.name,
              last_read_datetime: message.sent_at
            }

          _ ->
            %{
              existing_con
              | messages: [message | existing_con.messages],
                last_read_datetime: message.sent_at
            }
        end

      {existing_con, updated_con}
    end)
    updated_hash
  end
end
