defmodule DhSms.ConversationsTest do
  use DhSms.DataCase

  alias DhSms.Messaging
  alias DhSms.Messaging.{Campaign, Contact, Conversation, Message}

  describe "campaigns" do
    @valid_attrs %{intro_message: "some intro_message", name: "some name", send_delay: 42}
    @update_attrs %{intro_message: "some updated intro_message", name: "some updated name", send_delay: 43}
    @invalid_attrs %{intro_message: nil, name: nil, send_delay: nil}

    def campaign_fixture(attrs \\ %{}) do
      {:ok, campaign} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messaging.create_campaign()

      campaign
    end

    test "list_campaigns/0 returns all campaigns" do
      campaign = campaign_fixture()
      assert Messaging.list_campaigns() == [campaign]
    end

    test "get_campaign!/1 returns the campaign with given id" do
      campaign = campaign_fixture()
      assert Messaging.get_campaign!(campaign.id) == campaign
    end

    test "create_campaign/1 with valid data creates a campaign" do
      assert {:ok, %Campaign{} = campaign} = Messaging.create_campaign(@valid_attrs)
      assert campaign.intro_message == "some intro_message"
      assert campaign.name == "some name"
      assert campaign.send_delay == 42
    end

    test "create_campaign/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messaging.create_campaign(@invalid_attrs)
    end

    test "update_campaign/2 with valid data updates the campaign" do
      campaign = campaign_fixture()
      assert {:ok, %Campaign{} = campaign} = Messaging.update_campaign(campaign, @update_attrs)
      assert campaign.intro_message == "some updated intro_message"
      assert campaign.name == "some updated name"
      assert campaign.send_delay == 43
    end

    test "update_campaign/2 with invalid data returns error changeset" do
      campaign = campaign_fixture()
      assert {:error, %Ecto.Changeset{}} = Messaging.update_campaign(campaign, @invalid_attrs)
      assert campaign == Messaging.get_campaign!(campaign.id)
    end

    test "delete_campaign/1 deletes the campaign" do
      campaign = campaign_fixture()
      assert {:ok, %Campaign{}} = Messaging.delete_campaign(campaign)
      assert_raise Ecto.NoResultsError, fn -> Messaging.get_campaign!(campaign.id) end
    end

    test "change_campaign/1 returns a campaign changeset" do
      campaign = campaign_fixture()
      assert %Ecto.Changeset{} = Messaging.change_campaign(campaign)
    end
  end

  describe "conversations" do
    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{campaign_id: nil}

    def conversation_fixture(attrs \\ %{}) do
      {:ok, conversation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messaging.create_conversation()

      conversation
    end

    setup do
      {:ok, campaign} =
        %{intro_message: "some intro_message", name: "some name", send_delay: 42}
        |> Messaging.create_campaign()

      {:ok, contact} =
        %{name: "Some Name", email: "example@example.com", phone: "0000000000"}
        |> Messaging.create_contact()

      %{campaign: campaign, contact: contact}
    end

    test "list_conversations/0 returns all conversations", %{campaign: campaign, contact: contact} do
      conversation = conversation_fixture(campaign_id: campaign.id, contact_id: contact.id)
      assert Messaging.list_conversations() == [conversation]
    end

    test "get_conversation!/1 returns the conversation with given id", %{campaign: campaign, contact: contact} do
      conversation = conversation_fixture(campaign_id: campaign.id, contact_id: contact.id)
      assert Messaging.get_conversation!(conversation.id) == conversation
    end

    test "create_conversation/1 with valid data creates a conversation", %{campaign: campaign, contact: contact} do
      attrs =
        %{campaign_id: campaign.id, contact_id: contact.id}
        |> Enum.into(@valid_attrs)

      assert {:ok, %Conversation{} = conversation} = Messaging.create_conversation(attrs)
    end

    test "create_conversation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messaging.create_conversation(@invalid_attrs)
    end

    test "update_conversation/2 with valid data updates the conversation", %{campaign: campaign, contact: contact} do
      conversation = conversation_fixture(campaign_id: campaign.id, contact_id: contact.id)
      assert {:ok, %Conversation{} = conversation} = Messaging.update_conversation(conversation, @update_attrs)
    end

    test "update_conversation/2 with invalid data returns error changeset", %{campaign: campaign, contact: contact} do
      conversation = conversation_fixture(campaign_id: campaign.id, contact_id: contact.id)

      assert {:error, %Ecto.Changeset{}} = Messaging.update_conversation(conversation, @invalid_attrs)
      assert conversation == Messaging.get_conversation!(conversation.id)
    end

    test "delete_conversation/1 deletes the conversation", %{campaign: campaign, contact: contact} do
      conversation = conversation_fixture(campaign_id: campaign.id, contact_id: contact.id)
      assert {:ok, %Conversation{}} = Messaging.delete_conversation(conversation)
      assert_raise Ecto.NoResultsError, fn -> Messaging.get_conversation!(conversation.id) end
    end

    test "change_conversation/1 returns a conversation changeset", %{campaign: campaign, contact: contact} do
      conversation = conversation_fixture(campaign_id: campaign.id, contact_id: contact.id)
      assert %Ecto.Changeset{} = Messaging.change_conversation(conversation)
    end
  end

  describe "contacts" do
    @valid_attrs %{email: "some email", name: "some name", phone: "some phone"}
    @update_attrs %{email: "some updated email", name: "some updated name", phone: "some updated phone"}
    @invalid_attrs %{email: nil, name: nil, phone: nil}

    def contact_fixture(attrs \\ %{}) do
      {:ok, contact} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messaging.create_contact()

      contact
    end

    test "list_contacts/0 returns all contacts" do
      contact = contact_fixture()
      assert Messaging.list_contacts() == [contact]
    end

    test "get_contact!/1 returns the contact with given id" do
      contact = contact_fixture()
      assert Messaging.get_contact!(contact.id) == contact
    end

    test "create_contact/1 with valid data creates a contact" do
      assert {:ok, %Contact{} = contact} = Messaging.create_contact(@valid_attrs)
      assert contact.email == "some email"
      assert contact.name == "some name"
      assert contact.phone == "some phone"
    end

    test "create_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messaging.create_contact(@invalid_attrs)
    end

    test "update_contact/2 with valid data updates the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{} = contact} = Messaging.update_contact(contact, @update_attrs)
      assert contact.email == "some updated email"
      assert contact.name == "some updated name"
      assert contact.phone == "some updated phone"
    end

    test "update_contact/2 with invalid data returns error changeset" do
      contact = contact_fixture()

      assert {:error, %Ecto.Changeset{}} = Messaging.update_contact(contact, @invalid_attrs)
      assert contact == Messaging.get_contact!(contact.id)
    end

    test "delete_contact/1 deletes the contact" do
      contact = contact_fixture()

      assert {:ok, %Contact{}} = Messaging.delete_contact(contact)
      assert_raise Ecto.NoResultsError, fn -> Messaging.get_contact!(contact.id) end
    end

    test "change_contact/1 returns a contact changeset" do
      contact = contact_fixture()

      assert %Ecto.Changeset{} = Messaging.change_contact(contact)
    end
  end

  describe "messages" do
    @valid_attrs %{body: "some body"}
    @update_attrs %{body: "some updated body"}
    @invalid_attrs %{body: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messaging.create_message()

      message
    end

    setup do
      {:ok, campaign} =
        %{intro_message: "some intro_message", name: "some name", send_delay: 42}
        |> Messaging.create_campaign()

      {:ok, contact} =
        %{name: "Some Name", email: "example@example.com", phone: "0000000000"}
        |> Messaging.create_contact()

      {:ok, conversation} =
        %{campaign_id: campaign.id, contact_id: contact.id}
        |> Messaging.create_conversation()

      %{campaign: campaign, contact: contact, conversation: conversation}
    end

    test "list_messages/0 returns all messages", %{conversation: conversation} do
      message = message_fixture(conversation_id: conversation.id)
      assert Messaging.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id", %{conversation: conversation} do
      message = message_fixture(conversation_id: conversation.id)
      assert Messaging.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message", %{conversation: conversation} do
      attrs = Enum.into(%{conversation_id: conversation.id}, @valid_attrs)
      message = Messaging.create_message(attrs)

      assert {:ok, %Message{} = message} = message
      assert message.body == "some body"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messaging.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message", %{conversation: conversation} do
      message = message_fixture(conversation_id: conversation.id)
      attrs = Enum.into(%{conversation_id: conversation.id}, @update_attrs)
      assert {:ok, %Message{} = message} = Messaging.update_message(message, attrs)
      assert message.body == "some updated body"
    end

    test "update_message/2 with invalid data returns error changeset", %{conversation: conversation} do
      message = message_fixture(conversation_id: conversation.id)
      assert {:error, %Ecto.Changeset{}} = Messaging.update_message(message, @invalid_attrs)
      assert message == Messaging.get_message!(message.id)
    end

    test "delete_message/1 deletes the message", %{conversation: conversation} do
      message = message_fixture(conversation_id: conversation.id)
      assert {:ok, %Message{}} = Messaging.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messaging.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset", %{conversation: conversation} do
      message = message_fixture(conversation_id: conversation.id)
      assert %Ecto.Changeset{} = Messaging.change_message(message)
    end
  end
end
