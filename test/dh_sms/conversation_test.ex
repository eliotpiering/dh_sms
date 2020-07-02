defmodule DhSms.ConversationTest do
  alias DhSms.Conversation
  alias DhSms.TestMessage

  use ExUnit.Case

  describe "build_from_messages" do
    def build_messages(count) do
      TestMessage.build_messages(count)
    end

    test "build_from_messages returns a conversation hash" do
      messages = build_messages(10)
      first_msg = messages |> List.first()
      conversation_hash = messages |> Conversation.build_from_messages()

      sorted_keys = Enum.map(messages, fn m -> m.contact_id |> to_string end) |> Enum.sort()

      assert Map.keys(conversation_hash) |> Enum.sort() == sorted_keys
      conversation = Map.get(conversation_hash, first_msg.contact_id |> to_string)

      assert conversation == %Conversation{
               messages: [first_msg],
               contact_name: first_msg.name,
               contact_id: first_msg.contact_id,
               last_sent_datetime: first_msg.sent_at
             }
    end
  end
end
