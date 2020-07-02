defmodule DhSms.ConversationsTest do
  use DhSms.DataCase

  alias DhSms.Conversations

  describe "conversations" do
    alias DhSms.Conversations.Conversation

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{nonexistant_attr: 2}

    def conversation_fixture(attrs \\ %{}) do
      {:ok, conversation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Conversations.create_conversation()

      conversation
    end

    test "list_conversations/0 returns all conversations" do
      conversation = conversation_fixture()
      assert Conversations.list_conversations() == [conversation]
    end

    test "get_conversation!/1 returns the conversation with given id" do
      conversation = conversation_fixture()
      assert Conversations.get_conversation!(conversation.id) == conversation
    end

    test "create_conversation/1 with valid data creates a conversation" do
      assert {:ok, %Conversation{} = conversation} = Conversations.create_conversation(@valid_attrs)
    end

    @tag :skip
    test "create_conversation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Conversations.create_conversation(@invalid_attrs)
    end

    test "update_conversation/2 with valid data updates the conversation" do
      conversation = conversation_fixture()
      assert {:ok, %Conversation{} = conversation} = Conversations.update_conversation(conversation, @update_attrs)
    end

    @tag :skip
    test "update_conversation/2 with invalid data returns error changeset" do
      conversation = conversation_fixture()
      assert {:error, %Ecto.Changeset{}} = Conversations.update_conversation(conversation, @invalid_attrs)
      assert conversation == Conversations.get_conversation!(conversation.id)
    end

    test "delete_conversation/1 deletes the conversation" do
      conversation = conversation_fixture()
      assert {:ok, %Conversation{}} = Conversations.delete_conversation(conversation)
      assert_raise Ecto.NoResultsError, fn -> Conversations.get_conversation!(conversation.id) end
    end

    test "change_conversation/1 returns a conversation changeset" do
      conversation = conversation_fixture()
      assert %Ecto.Changeset{} = Conversations.change_conversation(conversation)
    end
  end

  describe "contacts" do
    alias DhSms.Conversations.Contact

    @valid_attrs %{email: "some email", name: "some name", phone: "some phone"}
    @update_attrs %{email: "some updated email", name: "some updated name", phone: "some updated phone"}
    @invalid_attrs %{email: nil, name: nil, phone: nil}

    def contact_fixture(attrs \\ %{}) do
      {:ok, contact} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Conversations.create_contact()

      contact
    end

    test "list_contacts/0 returns all contacts" do
      conversation = conversation_fixture()
      contact = contact_fixture(conversation_id: conversation.id)
      assert Conversations.list_contacts(conversation.id) == [contact]
    end

    test "get_contact!/1 returns the contact with given id" do
      conversation = conversation_fixture()
      contact = contact_fixture(conversation_id: conversation.id)
      assert Conversations.get_contact!(conversation.id, contact.id) == contact
    end

    test "create_contact/1 with valid data creates a contact" do
      conversation = conversation_fixture()
      valid_attrs = Enum.into(%{conversation_id: conversation.id}, @valid_attrs)

      assert {:ok, %Contact{} = contact} = Conversations.create_contact(valid_attrs)
      assert contact.email == "some email"
      assert contact.name == "some name"
      assert contact.phone == "some phone"
    end

    test "create_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Conversations.create_contact(@invalid_attrs)
    end

    test "update_contact/2 with valid data updates the contact" do
      conversation = conversation_fixture()
      contact = contact_fixture(conversation_id: conversation.id)
      assert {:ok, %Contact{} = contact} = Conversations.update_contact(contact, @update_attrs)
      assert contact.email == "some updated email"
      assert contact.name == "some updated name"
      assert contact.phone == "some updated phone"
    end

    test "update_contact/2 with invalid data returns error changeset" do
      conversation = conversation_fixture()
      contact = contact_fixture(conversation_id: conversation.id)

      assert {:error, %Ecto.Changeset{}} = Conversations.update_contact(contact, @invalid_attrs)
      assert contact == Conversations.get_contact!(conversation.id, contact.id)
    end

    test "delete_contact/1 deletes the contact" do
      conversation = conversation_fixture()
      contact = contact_fixture(conversation_id: conversation.id)

      assert {:ok, %Contact{}} = Conversations.delete_contact(contact)
      assert_raise Ecto.NoResultsError, fn -> Conversations.get_contact!(conversation.id, contact.id) end
    end

    test "change_contact/1 returns a contact changeset" do
      conversation = conversation_fixture()
      contact = contact_fixture(conversation_id: conversation.id)

      assert %Ecto.Changeset{} = Conversations.change_contact(contact)
    end
  end

  describe "messages" do
    alias DhSms.Conversations.Message

    @valid_attrs %{body: "some body", from_dh: false}
    @update_attrs %{body: "some updated body"}
    @invalid_attrs %{body: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Conversations.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      conversation = conversation_fixture()
      message = message_fixture(conversation_id: conversation.id)
      assert Conversations.list_messages(conversation.id) == [message]
    end

    test "get_message!/1 returns the message with given id" do
      conversation = conversation_fixture()
      message = message_fixture(conversation_id: conversation.id)
      assert Conversations.get_message!(conversation.id, message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      conversation = conversation_fixture()
      attrs = Enum.into(%{conversation_id: conversation.id}, @valid_attrs)
      message = Conversations.create_message(attrs)

      assert {:ok, %Message{} = message} = message
      assert message.body == "some body"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Conversations.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      conversation = conversation_fixture()
      message = message_fixture(conversation_id: conversation.id)
      attrs = Enum.into(%{conversation_id: conversation.id}, @update_attrs)
      assert {:ok, %Message{} = message} = Conversations.update_message(message, attrs)
      assert message.body == "some updated body"
    end

    test "update_message/2 with invalid data returns error changeset" do
      conversation = conversation_fixture()
      message = message_fixture(conversation_id: conversation.id)
      assert {:error, %Ecto.Changeset{}} = Conversations.update_message(message, @invalid_attrs)
      assert message == Conversations.get_message!(conversation.id, message.id)
    end

    test "delete_message/1 deletes the message" do
      conversation = conversation_fixture()
      message = message_fixture(conversation_id: conversation.id)
      assert {:ok, %Message{}} = Conversations.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Conversations.get_message!(conversation.id, message.id) end
    end

    test "change_message/1 returns a message changeset" do
      conversation = conversation_fixture()
      message = message_fixture(conversation_id: conversation.id)
      assert %Ecto.Changeset{} = Conversations.change_message(message)
    end
  end
end
